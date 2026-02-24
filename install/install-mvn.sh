#!/usr/bin/env bash
set -euo pipefail

VERSION="3.9.12"
FILE="apache-maven-${VERSION}-bin.tar.gz"
URL="https://downloads.apache.org/maven/maven-3/${VERSION}/binaries/${FILE}"

INSTALL_DIR="$HOME/.local/maven"
TMP_DIR="$(mktemp -d)"

echo "Downloading Maven ${VERSION} …"
curl -fsSL "$URL" -o "$TMP_DIR/$FILE"

echo "Extracting …"
mkdir -p "$INSTALL_DIR"
tar -xzf "$TMP_DIR/$FILE" -C "$INSTALL_DIR" --strip-components=1

rm -rf "$TMP_DIR"

echo
echo "Installed to: $INSTALL_DIR"
echo

if ! echo "$PATH" | grep -q "$INSTALL_DIR/bin"; then
  echo "Add to PATH:"
  echo '  export PATH="$HOME/.local/maven/bin:$PATH"'
fi

echo
echo "Version:"
"$INSTALL_DIR/bin/mvn" -version || true