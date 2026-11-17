#!/usr/bin/env bash
set -euo pipefail

NODE_BIN="$HOME/.local/node/bin"
NPM_BIN="$NODE_BIN/npm"

if [ ! -x "$NPM_BIN" ]; then
    echo "npm not found: $NPM_BIN"
    echo "Install Node.js first."
    exit 1
fi

export PATH="$NODE_BIN:$PATH"

echo "Installing pnpm …"
"$NPM_BIN" install -g pnpm

echo
echo "Installed:"
echo "  $(command -v pnpm)"
echo
echo "Version:"
pnpm --version