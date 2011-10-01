/**
 * Copyright (c) 2008 - 2009 by Eric Van Dewoestine
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 *
 * Plugin to facilitate frame navigation by mimicking vim's
 * <c-w>/:wincmd functionality.
 *
 * Usage:
 *   [count]<c-w>j
 *   [count]<c-w><c-j>
 *      Moves focus one or more frames below the current frame.
 *
 *   [count]<c-w>k
 *   [count]<c-w><c-k>
 *      Moves focus one or more frames above the current frame.
 *
 *   [count]<c-w>l
 *   [count]<c-w><c-l>
 *      Moves focus one or more frames to the left of the current frame.
 *
 *   [count]<c-w>h
 *   [count]<c-w><c-h>
 *      Moves focus one or more frames to the right of the current frame.
 *
 *   [count]<c-w>w
 *   [count]<c-w><c-w>
 *
 *   The above commands can also be executed with ":wincmd":
 *
 *   :[count]wincm[d] {arg}
 *       Equivalent to executing [count]<c-w>{arg}
 *
 *   Note: none of the above will wrap around should you reach the edge of
 *   which ever direction you are moving, with the exception of <c-w> which
 *   will cycle through all frames, wrapping back to beginning after reaching
 *   the last frame.
 *
 *   Firebug users: <c-w> and :wincmd commands can also be used to focus
 *   firebug panels.  Combined with the firebug plugin, you can navigate
 *   firebug like other web pages in vimperator.  See the firebug plugin for
 *   details on what features are currently provided.
 *
 * TODO
 *   - attempt to take cursor (caret) location into account.
 *   - frame filtering (ads, etc.)
 *   - shortcut to focus largest frame
 *   - integrate with the "SplitBrowser" addon and "splitBrowser.js" plugin.
 *   - if possible, add other wincmd equivalent commands
 *     (J, K, L, H, X, T, etc.)
 *
 * @version 0.4
 */
function Wincmd() {
  function dimensions(frame){
    var frameElement = frame.frameElement;
    var offsetTop = frameElement.offsetTop;
    var offsetLeft = frameElement.offsetLeft;
    var parent = frame.parent;
    if (parent != frame && parent.frameElement){
      do {
        offsetTop += parent.frameElement.offsetTop;
        offsetLeft += parent.frameElement.offsetLeft;
      } while((parent = parent.parent) && parent != frame && parent.frameElement)
    }
    return {
      top: offsetTop, bottom: offsetTop + frameElement.offsetHeight,
      left: offsetLeft, right: offsetLeft + frameElement.offsetWidth
    };
  }

  function firebugDimensions(panel){
    var contentBox = document.getElementById('fbContentBox');
    var offsetTop = contentBox.boxObject.y;
    var offsetLeft = contentBox.boxObject.x;
    return {
      top: offsetTop, bottom: offsetTop + contentBox.boxObject.height,
      left: offsetLeft, right: offsetLeft + panel.document.width
    };
  }

  return {
    nextVertical: function(count, current, frames, down){
      var next = current;
      for (var ii = 0; ii < count; ii++){
        var cdimen = next.dimensions;
        var ndimen = undefined;
        for (var jj = 0; jj < frames.length; jj++){
          frame = frames[jj];
          var fdimen = frame.dimensions;
          if ((
              (down && fdimen.top >= cdimen.bottom) ||
              (!down && fdimen.bottom <= cdimen.top)
          ) && (
              (fdimen.left > cdimen.left && fdimen.left < cdimen.right) ||
              (fdimen.right > cdimen.left && fdimen.right < cdimen.right) ||
              (fdimen.left <= cdimen.left && fdimen.right >= cdimen.right)
          ))
          {
            if(!ndimen || (
                (down && fdimen.top < ndimen.top) ||
                (!down && fdimen.bottom > ndimen.bottom))
            ){
              ndimen = fdimen;
              next = frame;
            }
          }
        }
      }
      return next;
    },

    nextHorizontal: function(count, current, frames, right){
      var next = current;
      for (var ii = 0; ii < count; ii++){
        var cdimen = next.dimensions;
        var ndimen = undefined;
        for (var jj = 0; jj < frames.length; jj++){
          frame = frames[jj];
          var fdimen = frame.dimensions;
          if ((
              (right && fdimen.left >= cdimen.right) ||
              (!right && fdimen.right <= cdimen.left)
          ) && (
              (fdimen.top > cdimen.top && fdimen.top < cdimen.bottom) ||
              (fdimen.bottom > cdimen.top && fdimen.bottom < cdimen.bottom) ||
              (fdimen.top <= cdimen.top && fdimen.bottom >= cdimen.bottom)
          ))
          {
            if(!ndimen || (
                (right && fdimen.left < ndimen.left) ||
                (!right && fdimen.right > ndimen.right))
            ){
              ndimen = fdimen;
              next = frame;
            }
          }
        }
      }
      return next;
    },

    // Mostly copied from buffer.shiftFrameFocus
    setFrameFocus: function(count, frameChooser){
      if (!window.content.document instanceof HTMLDocument)
        return;

      var frames = [];

      // find all frames - depth-first search
      (function(frame) {
          if (frame.document.body.localName.toLowerCase() == "body")
            frames.push(frame);
          Array.forEach(frame.frames, arguments.callee);
      })(window.content);

      // remove all unfocusable frames
      var start = document.commandDispatcher.focusedWindow;
      frames = frames.filter(function(frame) {
        frame.focus();
        if (frame.frameElement &&
          document.commandDispatcher.focusedWindow == frame)
        {
          frame.dimensions = dimensions(frame);
          return frame.dimensions ? true : false;
        }
        return false;
      });
      start.focus();

      // inject firebug 'frames' if firebug is open.
      var contentBox = document.getElementById('fbContentBox');
      if (contentBox && !contentBox.collapsed){
        // if no frames, then window.content becomes an honorary frame.
        if (frames.length === 0){
          window.content.dimensions = {
            top: 0, bottom: window.content.innerHeight,
            left: 0, right: window.content.innerWidth
          };
          frames.push(window.content);
        }
        var browser = FirebugChrome.getCurrentBrowser();
        var panel = browser.chrome.getSelectedPanel();
        var view = panel.document.defaultView;
        view.dimensions = firebugDimensions(panel);
        frames.push(view);
        var sidePanel = browser.chrome.getSelectedSidePanel();
        if (sidePanel){
          var sideView = sidePanel.document.defaultView;
          sideView.dimensions = firebugDimensions(sidePanel);
          sideView.dimensions.left = view.dimensions.right;
          frames.push(sideView);
        }
      }

      var doc = window.content.document;
      if (frames.length > 0){
        // find the currently focused frame index
        var currentIndex = frames.indexOf(document.commandDispatcher.focusedWindow);
        var current = currentIndex > -1 ? frames[currentIndex] : frames[0];

        var frame = frameChooser(count > 1 ? count : 1, current, frames);

        // focus next frame and scroll into view
        frame.focus();
        if (frame != window.content && frame.frameElement.scrollIntoView)
          frame.frameElement.scrollIntoView(false);

        doc = frame.document;
      }

      var indicator = util.xmlToDom(<div highlight="FrameIndicator"/>, doc);
      doc.body.appendChild(indicator);

      setTimeout(function() { doc.body.removeChild(indicator); }, 500);
    }
  }
}

var wcv = Wincmd();

commands.add(["wincm[d]"],
  "Change focus to a different frame",
  function(args) {
    count = args.count > 1 ? args.count : "";
    switch(args.string){
      case "j":
        wcv.setFrameFocus(count, function(count, current, frames){
          return wcv.nextVertical(count, current, frames, true);
        });
        break;
      case "k":
        wcv.setFrameFocus(count, function(count, current, frames){
          return wcv.nextVertical(count, current, frames, false);
        });
        break;
      case "h":
        wcv.setFrameFocus(count, function(count, current, frames){
          return wcv.nextHorizontal(count, current, frames, false);
        });
        break;
      case "l":
        wcv.setFrameFocus(count, function(count, current, frames){
          return wcv.nextHorizontal(count, current, frames, true);
        });
        break;
      case "w":
        wcv.setFrameFocus(count, function(count, current, frames){
          var currentIndex = frames.indexOf(current);
          if (currentIndex < frames.length - count){
            index = currentIndex + count;
          }else{
            index = currentIndex + count - frames.length;
          }
          return index < frames.length ? frames[index] : frames[frames.length - 1];
        });
        break;
      default:
        liberator.echoerr("unsupported argument for wincmd: " + args.string);
        return false;
    }
    return true;
  }, {count: true, argCount: 1}
);

mappings.add([modes.NORMAL], ["<C-w>w", "<C-w><C-w>"],
    "Cycle through frames",
    function(count) {
      count = count > 0 ? count : '';
      events.feedkeys(":" + count + "wincmd w<cr>");
    },
    { count: true }
);

mappings.add([modes.NORMAL], ["<C-w>j", "<C-w><C-j>"],
    "Move to the frame below the current one.",
    function(count) {
      count = count > 0 ? count : '';
      events.feedkeys(":" + count + "wincmd j<cr>");
    },
    { count: true }
);

mappings.add([modes.NORMAL], ["<C-w>k", "<C-w><C-k>"],
    "Move to the frame above the current one.",
    function(count) {
      count = count > 0 ? count : '';
      events.feedkeys(":" + count + "wincmd k<cr>");
    },
    { count: true }
);

mappings.add([modes.NORMAL], ["<C-w>l", "<C-w><C-l>"],
    "Move to the frame to the right of the current one.",
    function(count) {
      count = count > 0 ? count : '';
      events.feedkeys(":" + count + "wincmd l<cr>");
    },
    { count: true }
);

mappings.add([modes.NORMAL], ["<C-w>h", "<C-w><C-h>"],
    "Move to the frame to the left of the current one.",
    function(count) {
      count = count > 0 ? count : '';
      events.feedkeys(":" + count + "wincmd h<cr>");
    },
    { count: true }
);
