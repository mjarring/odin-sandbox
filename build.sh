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
  hellope       Builds hellope program
  sample_sdl    Builds SDL sample program
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

if [[ "${release:-0}" == "1" ]]; then
  echo "[release mode]"
  compile="odin build"
elif [[ "${debug:-1}" == "1" ]]; then
  echo "[debug mode]"
  compile="odin build -debug"
fi

# --- Prep Directories --------------------------------------------------------
mkdir -p build

# --- Build Everything (@build_targets) ---------------------------------------
cd build
if [[ "${hellope:-0}" == "1" ]]; then
  echo "[building hellope]"
  didbuild=1 && $compile ../hellope/
fi
if [[ "${sample_sdl:-0}" == "1" ]]; then
  echo "[building sample_sdl]"
  didbuild=1 && $compile ../sample_sdl/
fi
cd ..

# --- Warn On No Builds -------------------------------------------------------
if [[ "${didbuild:-0}" == "0" ]]; then
  echo "[WARNING] no valid build target specified; must use build target names as arguments to this script, like \`./build.sh <target>\`."
  exit 1
fi
