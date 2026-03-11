#!/usr/bin/env bash
set -euo pipefail

VERSION="v4.52.4"   # ggf. anpassen
FILE="yq_darwin_arm64"
URL="https://github.com/mikefarah/yq/releases/download/${VERSION}/${FILE}"

INSTALL_DIR="$HOME/.local/bin"
TMP_DIR="$(mktemp -d)"

echo "Downloading yq ${VERSION} …"
curl -fsSL "$URL" -o "$TMP_DIR/yq"

mkdir -p "$INSTALL_DIR"
mv "$TMP_DIR/yq" "$INSTALL_DIR/yq"
chmod +x "$INSTALL_DIR/yq"

rm -rf "$TMP_DIR"

echo
echo "Installed:"
echo "  $INSTALL_DIR/yq"
echo
echo "Version:"
"$INSTALL_DIR/yq" --version || true