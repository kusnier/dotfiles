#!/usr/bin/env bash
set -euo pipefail

MICROMAMBA_ROOT="$HOME/.local/micromamba"
ENV_PREFIX="$HOME/.local/graphviz-env"
BIN_DIR="$HOME/.local/bin"
TMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

mkdir -p "$BIN_DIR"
mkdir -p "$MICROMAMBA_ROOT"

if [ ! -x "$BIN_DIR/micromamba" ]; then
    echo "Installing micromamba ..."
    curl -Ls https://micro.mamba.pm/install.sh | bash -s -- -b "$BIN_DIR"
fi

export MAMBA_ROOT_PREFIX="$MICROMAMBA_ROOT"

if [ ! -d "$ENV_PREFIX" ]; then
    echo "Creating graphviz environment ..."
    "$BIN_DIR/micromamba" create -y -p "$ENV_PREFIX" -c conda-forge graphviz
else
    echo "Updating graphviz environment ..."
    "$BIN_DIR/micromamba" install -y -p "$ENV_PREFIX" -c conda-forge graphviz
fi

echo "Creating local wrapper ..."
cat > "$BIN_DIR/dot" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
exec "$HOME/.local/graphviz-env/bin/dot" "$@"
EOF
chmod +x "$BIN_DIR/dot"

cat > "$BIN_DIR/plantuml-with-graphviz" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
export GRAPHVIZ_DOT="$HOME/.local/graphviz-env/bin/dot"
exec plantuml "$@"
EOF
chmod +x "$BIN_DIR/plantuml-with-graphviz"

echo
echo "Installed:"
echo "  $ENV_PREFIX/bin/dot"
echo "  $BIN_DIR/dot"
echo "  $BIN_DIR/plantuml-with-graphviz"
echo
echo "Version:"
"$ENV_PREFIX/bin/dot" -V
echo
echo "Formats:"
"$ENV_PREFIX/bin/dot" -T? 2>&1 | head -n 2 || true
echo
echo "PlantUML test:"
echo "  GRAPHVIZ_DOT=\"$ENV_PREFIX/bin/dot\" plantuml -testdot"
echo ""
echo "Add this to fish.config"
echo " set -Ux fish_user_paths \$HOME/.local/bin \$fish_user_paths"
echo " set -Ux GRAPHVIZ_DOT \$HOME/.local/graphviz-env/bin/dot"