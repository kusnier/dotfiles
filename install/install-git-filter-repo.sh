#!/usr/bin/env bash
set -euo pipefail

VERSION="v2.47.0"
URL="https://raw.githubusercontent.com/newren/git-filter-repo/${VERSION}/git-filter-repo"

INSTALL_DIR="$HOME/.local/bin"
TARGET="$INSTALL_DIR/git-filter-repo"
TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

if ! command -v python3 >/dev/null 2>&1; then
    echo "Error: Python 3 is required."
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    echo "Error: Git is required."
    exit 1
fi

echo "Downloading git-filter-repo ${VERSION} …"
curl -fsSL "$URL" -o "$TMP_DIR/git-filter-repo"

echo "Installing …"
mkdir -p "$INSTALL_DIR"
install -m 755 "$TMP_DIR/git-filter-repo" "$TARGET"

echo
echo "Installed:"
echo "  $TARGET"
echo
echo "Version:"
"$TARGET" --version