#!/usr/bin/env bash
set -euo pipefail

VERSION="1.2026.2"
FILE="plantuml-gplv2-${VERSION}.jar"
URL="https://github.com/plantuml/plantuml/releases/download/v${VERSION}/${FILE}"

INSTALL_DIR="$HOME/.local/plantuml"
BIN_DIR="$HOME/.local/bin"
TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

command -v curl >/dev/null 2>&1 || { echo "curl fehlt"; exit 1; }
command -v java >/dev/null 2>&1 || { echo "java fehlt"; exit 1; }

mkdir -p "$INSTALL_DIR" "$BIN_DIR"

echo "Downloading PlantUML ${VERSION} …"
curl -fsSL "$URL" -o "$TMP_DIR/plantuml.jar"

mv "$TMP_DIR/plantuml.jar" "$INSTALL_DIR/plantuml.jar"

cat > "$BIN_DIR/plantuml" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
exec java -jar "$HOME/.local/plantuml/plantuml.jar" "$@"
EOF

chmod +x "$BIN_DIR/plantuml"

echo
echo "Installed:"
echo "  $INSTALL_DIR/plantuml.jar"
echo "  $BIN_DIR/plantuml"
echo
"$BIN_DIR/plantuml" -version || true