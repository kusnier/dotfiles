#!/usr/bin/env bash
set -euo pipefail

VERSION="v22.22.1"
FILE="node-$VERSION-darwin-arm64.tar.gz"
URL="https://nodejs.org/dist/$VERSION/$FILE"

BASE_DIR="$HOME/.local/node"
TMP_DIR="$(mktemp -d)"

echo "Downloading $FILE …"
curl -fsSL "$URL" -o "$TMP_DIR/$FILE"

echo "Extracting …"
mkdir -p "$BASE_DIR"
tar -xzf "$TMP_DIR/$FILE" -C "$BASE_DIR" --strip-components=1

echo "Cleanup …"
rm -rf "$TMP_DIR"

echo
echo "Installed to: $BASE_DIR"
echo

# PATH Hinweis
if ! echo "$PATH" | grep -q "$BASE_DIR/bin"; then
  echo "Add to PATH:"
  echo '  export PATH="$HOME/.local/node/bin:$PATH"'
fi

echo
echo "Versions:"
"$BASE_DIR/bin/node" --version
"$BASE_DIR/bin/npm" --version
