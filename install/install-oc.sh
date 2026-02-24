#!/usr/bin/env bash
set -euo pipefail

# Version anpassen falls nötig
VERSION="4.15.0"

FILE="openshift-client-mac-${VERSION}.tar.gz"
URL="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${VERSION}/${FILE}"

INSTALL_DIR="$HOME/.local/bin"
TMP_DIR="$(mktemp -d)"

echo "Downloading oc ${VERSION} …"
curl -fsSL "$URL" -o "$TMP_DIR/$FILE"

echo "Extracting …"
tar -xzf "$TMP_DIR/$FILE" -C "$TMP_DIR"

mkdir -p "$INSTALL_DIR"

# oc und kubectl liegen im Tarball
mv "$TMP_DIR/oc" "$INSTALL_DIR/oc"
mv "$TMP_DIR/kubectl" "$INSTALL_DIR/kubectl"

chmod +x "$INSTALL_DIR/oc" "$INSTALL_DIR/kubectl"

rm -rf "$TMP_DIR"

echo
echo "Installed:"
echo "  $INSTALL_DIR/oc"
echo "  $INSTALL_DIR/kubectl"
echo
echo "Version:"
"$INSTALL_DIR/oc" version --client || true