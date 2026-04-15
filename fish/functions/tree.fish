function tree --description "tree fallback (proper branching) using python3; supports bundled flags like -ChFL 1, --dirsfirst, -a, emojis"
    if not command -q python3
        echo "tree fallback needs python3 (not found)."
        return 127
    end

    set -l py '
import os, sys

def parse_args(argv):
    opt = {
        "max_depth": 999999,
        "dirsfirst": False,
        "show_all": False,
        "path": ".",
        "ignore": {".git", "node_modules"},
        "emojis": True,
    }
    want_depth = False
    i = 0
    while i < len(argv):
        a = argv[i]

        if want_depth:
            try:
                opt["max_depth"] = int(a)
            except ValueError:
                pass
            want_depth = False
            i += 1
            continue

        if a == "--dirsfirst":
            opt["dirsfirst"] = True
            i += 1
            continue

        if a == "-a":
            opt["show_all"] = True
            i += 1
            continue

        if a == "--ignore":
            if i + 1 < len(argv):
                opt["ignore"].add(argv[i + 1])
                i += 2
                continue
            i += 1
            continue

        if a == "-L":
            want_depth = True
            i += 1
            continue

        if a.startswith("-L") and len(a) > 2 and a[2:].isdigit():
            opt["max_depth"] = int(a[2:])
            i += 1
            continue

        # bundled short flags like -ChFL 1 (care only about a and L)
        if a.startswith("-") and not a.startswith("--") and len(a) > 2:
            bundle = a[1:]
            if "a" in bundle:
                opt["show_all"] = True
            if "L" in bundle:
                want_depth = True
            i += 1
            continue

        # non-flag: treat as path candidate (use last existing)
        if not a.startswith("-") and os.path.exists(a):
            opt["path"] = a

        i += 1

    return opt

def should_skip(name, opt):
    if name in opt["ignore"]:
        return True
    if (not opt["show_all"]) and name.startswith("."):
        return True
    return False

def icon(entry, opt):
    if not opt["emojis"]:
        return ""
    try:
        if entry.is_symlink():
            return "🔗 "
        if entry.is_dir(follow_symlinks=False):
            return "📁 "
    except OSError:
        pass
    return "📄 "

def iter_children(path, opt):
    try:
        with os.scandir(path) as it:
            items = [e for e in it if not should_skip(e.name, opt)]
    except (FileNotFoundError, NotADirectoryError, PermissionError):
        return []

    def key(e):
        try:
            is_dir = e.is_dir(follow_symlinks=False)
        except OSError:
            is_dir = False
        if opt["dirsfirst"]:
            return (0 if is_dir else 1, e.name.casefold())
        return (e.name.casefold(),)

    items.sort(key=key)
    return items

def walk(dir_path, prefix, depth, opt):
    if depth >= opt["max_depth"]:
        return

    children = iter_children(dir_path, opt)
    total = len(children)

    for idx, entry in enumerate(children):
        last = (idx == total - 1)
        branch = "└── " if last else "├── "
        print(prefix + branch + icon(entry, opt) + entry.name)

        try:
            is_dir = entry.is_dir(follow_symlinks=False)
        except OSError:
            is_dir = False

        if is_dir:
            extension = "    " if last else "│   "
            walk(entry.path, prefix + extension, depth + 1, opt)

def main():
    opt = parse_args(sys.argv[1:])
    root = os.path.normpath(opt["path"])
    walk(root, "  ", 0, opt)

if __name__ == "__main__":
    main()
'

    # -c takes the script as one argument; $argv passes through to python as script args
    python3 -c $py -- $argv
end
