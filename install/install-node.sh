#!/usr/bin/env bash
set -euo pipefail

VERSION="v24.22.3"
ARCH="$(uname -m)"
OS="$(uname -s)"

BASE_DIR="$HOME/.local/node"
TMP_DIR="$(mktemp -d)"
STAGING_DIR="$TMP_DIR/node"

cleanup() {
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT

if [[ "$OS" != "Darwin" ]]; then
    echo "Error: Only macOS is supported."
    exit 1
fi

case "$ARCH" in
    arm64)
        NODE_ARCH="arm64"
        ;;
    x86_64)
        NODE_ARCH="x64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

FILE="node-${VERSION}-darwin-${NODE_ARCH}.tar.gz"
URL="https://nodejs.org/dist/${VERSION}/${FILE}"

echo "=================================="
echo " Node.js Clean Installation"
echo "=================================="
echo "Version: $VERSION"
echo "Architecture: $NODE_ARCH"
echo "Target: $BASE_DIR"
echo

echo "Downloading $FILE ..."
curl --fail --location --silent --show-error \
    "$URL" \
    --output "$TMP_DIR/$FILE"

echo "Extracting ..."
mkdir -p "$STAGING_DIR"

tar -xzf "$TMP_DIR/$FILE" \
    -C "$STAGING_DIR" \
    --strip-components=1

echo "Validating new installation ..."

"$STAGING_DIR/bin/node" --version
"$STAGING_DIR/bin/npm" --version

echo
echo "Removing previous installation ..."

if [[ -d "$BASE_DIR" ]]; then
    rm -rf "$BASE_DIR"
fi

echo "Installing Node.js ..."
mkdir -p "$(dirname "$BASE_DIR")"
mv "$STAGING_DIR" "$BASE_DIR"

echo
echo "=================================="
echo " Installation completed"
echo "=================================="

export PATH="$BASE_DIR/bin:$PATH"

echo
echo "Node.js:"
node --version

echo
echo "npm:"
npm --version

echo
echo "Node path:"
command -v node

echo
echo "npm path:"
command -v npm