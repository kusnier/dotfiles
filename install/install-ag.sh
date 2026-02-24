#!/usr/bin/env bash
set -euo pipefail

# Installs "ag" (The Silver Searcher) into ~/.local WITHOUT sudo on macOS (darwin-arm64).
# It builds dependencies into the same prefix if they are missing:
#   - PCRE 8.x (ag uses PCRE, not PCRE2)
#   - xz/liblzma (optional but commonly used)

PREFIX="${HOME}/.local"
BIN_DIR="${PREFIX}/bin"
INC_DIR="${PREFIX}/include"
LIB_DIR="${PREFIX}/lib"

AG_VERSION="2.2.0"
# IMPORTANT: Use the RELEASE tarball (contains ./configure). GitHub codeload snapshots often don't.
AG_TARBALL_URL="http://geoff.greer.fm/ag/releases/the_silver_searcher-${AG_VERSION}.tar.gz"

PCRE_VERSION="8.45"
PCRE_URL="https://downloads.sourceforge.net/project/pcre/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.tar.gz"

XZ_VERSION="5.4.6"
XZ_URL="https://downloads.sourceforge.net/project/lzmautils/xz-${XZ_VERSION}.tar.gz"

JOBS="$(sysctl -n hw.ncpu 2>/dev/null || echo 4)"

TMP_DIR="$(mktemp -d)"
SRC_DIR="${TMP_DIR}/src"

cleanup() { rm -rf "${TMP_DIR}"; }
trap cleanup EXIT

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1"
    exit 1
  }
}

download() {
  local url="$1"
  local out="$2"
  curl -fsSL "$url" -o "$out"
}

# --- prerequisites ---
need_cmd curl
need_cmd tar
need_cmd make

if command -v clang >/dev/null 2>&1; then
  CC=clang
elif command -v cc >/dev/null 2>&1; then
  CC=cc
else
  echo "No C compiler found (need clang or cc). Install Xcode Command Line Tools."
  exit 1
fi

mkdir -p "${SRC_DIR}" "${PREFIX}" "${BIN_DIR}"

echo "Prefix: ${PREFIX}"
echo "Compiler: ${CC}"
echo "Jobs: ${JOBS}"
echo

# Prefer our prefix during builds
export CPPFLAGS="-I${INC_DIR}"
export LDFLAGS="-L${LIB_DIR}"
export PKG_CONFIG_PATH="${LIB_DIR}/pkgconfig:${PKG_CONFIG_PATH:-}"

# --- build PCRE if missing in our prefix ---
if [[ -f "${INC_DIR}/pcre.h" ]] && (ls "${LIB_DIR}"/libpcre* >/dev/null 2>&1); then
  echo "PCRE already present in ${PREFIX}. Skipping PCRE build."
else
  echo "Building PCRE ${PCRE_VERSION} into ${PREFIX} …"
  PCRE_TGZ="${SRC_DIR}/pcre-${PCRE_VERSION}.tar.gz"
  download "${PCRE_URL}" "${PCRE_TGZ}"
  tar -xzf "${PCRE_TGZ}" -C "${SRC_DIR}"
  pushd "${SRC_DIR}/pcre-${PCRE_VERSION}" >/dev/null

  ./configure --prefix="${PREFIX}" --disable-dependency-tracking
  make -j"${JOBS}"
  make install

  popd >/dev/null
fi
echo

# --- build xz/liblzma if missing in our prefix ---
if [[ -f "${INC_DIR}/lzma.h" ]] && (ls "${LIB_DIR}"/liblzma* >/dev/null 2>&1); then
  echo "liblzma already present in ${PREFIX}. Skipping xz build."
else
  echo "Building xz/liblzma ${XZ_VERSION} into ${PREFIX} …"
  XZ_TGZ="${SRC_DIR}/xz-${XZ_VERSION}.tar.gz"
  download "${XZ_URL}" "${XZ_TGZ}"
  tar -xzf "${XZ_TGZ}" -C "${SRC_DIR}"
  pushd "${SRC_DIR}/xz-${XZ_VERSION}" >/dev/null

  ./configure --prefix="${PREFIX}" --disable-dependency-tracking --disable-scripts
  make -j"${JOBS}"
  make install

  popd >/dev/null
fi
echo

# --- build ag ---
echo "Building ag (The Silver Searcher) ${AG_VERSION} into ${PREFIX} …"
AG_TGZ="${SRC_DIR}/the_silver_searcher-${AG_VERSION}.tar.gz"
download "${AG_TARBALL_URL}" "${AG_TGZ}"
tar -xzf "${AG_TGZ}" -C "${SRC_DIR}"

AG_DIR="${SRC_DIR}/the_silver_searcher-${AG_VERSION}"
if [[ ! -d "${AG_DIR}" ]]; then
  echo "Could not locate extracted ag source dir: ${AG_DIR}"
  exit 1
fi

pushd "${AG_DIR}" >/dev/null

if [[ ! -x "./configure" ]]; then
  echo "Error: ./configure not found. (Wrong tarball?)"
  exit 1
fi

# Hint configure to use our prefix libs/headers
export PCRE_CFLAGS="-I${INC_DIR}"
export PCRE_LIBS="-L${LIB_DIR} -lpcre"
export LZMA_CFLAGS="-I${INC_DIR}"
export LZMA_LIBS="-L${LIB_DIR} -llzma"

./configure --prefix="${PREFIX}"
make -j"${JOBS}"
make install

popd >/dev/null

echo
echo "Done."
echo "Installed: ${BIN_DIR}/ag"
echo
echo "PATH hint:"
echo "  export PATH=\"${BIN_DIR}:\$PATH\""
echo
echo "Version:"
"${BIN_DIR}/ag" --version || true
