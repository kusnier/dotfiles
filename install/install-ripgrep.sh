#!/usr/bin/env bash
set -euo pipefail

VERSION="15.1.0"
FILE="ripgrep-${VERSION}-aarch64-apple-darwin.tar.gz"
URL="https://github.com/BurntSushi/ripgrep/releases/download/${VERSION}/${FILE}"

INSTALL_DIR="$HOME/.local/bin"
TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Downloading ripgrep ${VERSION} …"
curl -fsSL "$URL" -o "$TMP_DIR/$FILE"

echo "Extracting …"
tar -xzf "$TMP_DIR/$FILE" -C "$TMP_DIR"

SOURCE_DIR="$TMP_DIR/ripgrep-${VERSION}-aarch64-apple-darwin"

if [ ! -x "$SOURCE_DIR/rg" ]; then
    echo "Error: rg binary not found"
    exit 1
fi

echo "Installing …"
mkdir -p "$INSTALL_DIR"
cp "$SOURCE_DIR/rg" "$INSTALL_DIR/rg"
chmod +x "$INSTALL_DIR/rg"

echo
echo "Installed:"
echo "  $INSTALL_DIR/rg"
echo
echo "Version:"
"$INSTALL_DIR/rg" --version