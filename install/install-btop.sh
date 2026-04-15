#!/usr/bin/env bash
set -euo pipefail

VERSION="v1.4.6"
URL="https://github.com/aristocratos/btop/archive/refs/tags/${VERSION}.tar.gz"

PREFIX="$HOME/.local"
BIN_DIR="$PREFIX/bin"
TMP_DIR="$(mktemp -d)"

echo "Downloading btop ${VERSION} source …"
curl -fsSL "$URL" -o "$TMP_DIR/btop.tar.gz"

echo "Extracting …"
tar -xzf "$TMP_DIR/btop.tar.gz" -C "$TMP_DIR"

cd "$TMP_DIR/btop-${VERSION#v}"

echo "Building …"
make -j"$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"

mkdir -p "$BIN_DIR"
cp bin/btop "$BIN_DIR/btop"
chmod +x "$BIN_DIR/btop"

rm -rf "$TMP_DIR"

echo
echo "Installed:"
echo "  $BIN_DIR/btop"
echo
echo "Version:"
"$BIN_DIR/btop" --version || true