if (window.location.pathname.match('/network/people/')) {
  $("img[src='/network/people/static/image/vcard.png']").parent().remove();
}

if (window.location.pathname.match('^/$')) {
  $("#stockContainer").parent().remove();
  $("#tabs_pr_languages").parent().remove();
}
