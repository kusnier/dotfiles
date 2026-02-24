#!/usr/bin/env bash
set -euo pipefail

VERSION="0.67.0"
FILE="fzf-${VERSION}-darwin_arm64.tar.gz"
URL="https://github.com/junegunn/fzf/releases/download/v${VERSION}/${FILE}"

INSTALL_DIR="$HOME/.local/bin"
TMP_DIR="$(mktemp -d)"

echo "Downloading $FILE …"
curl -L "$URL" -o "$TMP_DIR/$FILE"

echo "Extracting …"
tar -xzf "$TMP_DIR/$FILE" -C "$TMP_DIR"

echo "Installing to $INSTALL_DIR …"
mkdir -p "$INSTALL_DIR"
mv "$TMP_DIR/fzf" "$INSTALL_DIR/fzf"
chmod +x "$INSTALL_DIR/fzf"

echo "Cleanup …"
rm -rf "$TMP_DIR"

echo "Done."
echo "Make sure $INSTALL_DIR is in your PATH:"
echo '  export PATH="$HOME/.local/bin:$PATH"'
echo "Check with: fzf --version"
