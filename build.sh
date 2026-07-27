#!/bin/bash

set -eu
cd "$(dirname "$0")"

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS] [ARGS]

  Builds target program(s).

Options:
  -h, --help    Display this help message and exit.

Arguments:
  sample_sdl    Builds SDL sample program
  marathoner    Builds Marathoner application
  scanner       Builds odin-wayland scanner
EOF
}

# --- Unpack Arguments ---
for arg in "$@"; do
  if [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
    usage
    exit 0
  fi
  declare "$arg"='1'
done
if [[ "$#" == "0" ]]; then marathoner='1'; fi

# --- Compile Mode ---
if [[ "${release:-0}" == "1" ]]; then
  echo "[release mode]"
  compile="odin build"
  flags_mode=""
elif [[ "${debug:-1}" == "1" ]]; then
  echo "[debug mode]"
  compile="odin build"
  flags_mode="-debug -o:none"
fi

# --- Compile Flags ---
flags_common="-strict-style -vet -warnings-as-errors"
flags_all="$flags_mode $flags_common"

# --- Prep Directories --------------------------------------------------------
mkdir -p build

# --- Build Everything (@build_targets) ---------------------------------------
cd build
if [[ "${sample_sdl:-0}" == "1" ]]; then
  echo "[building sample_sdl]"
  didbuild=1 && $compile $flags_all ../src/sample_sdl/
fi
if [[ "${marathoner:-0}" == "1" ]]; then
  echo "[building marathoner]"
  didbuild=1 && $compile $flags_all ../src/marathoner/
fi
if [[ "${scanner:-0}" == "1" ]]; then
  echo "[building scanner]"
  didbuild=1 && $compile $flags_all ../src/odin-wayland/scanner/
fi
cd ..

# --- Warn On No Builds -------------------------------------------------------
if [[ "${didbuild:-0}" == "0" ]]; then
  echo "[WARNING] no valid build target specified; must use build target names as arguments to this script, like \`./build.sh <target>\`."
  exit 1
fi
