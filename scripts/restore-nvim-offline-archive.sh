#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: restore-nvim-offline-archive.sh archive.tar.gz

Restores an offline Neovim archive into the current home directory.

Environment overrides:
  NVIM_HOME     Base home directory to restore into (default: $HOME)
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

ARCHIVE="${1:-}"
if [[ -z "$ARCHIVE" ]]; then
  usage
  exit 1
fi

if [[ ! -f "$ARCHIVE" ]]; then
  printf 'Archive not found: %s\n' "$ARCHIVE" >&2
  exit 1
fi

HOME_DIR="${NVIM_HOME:-$HOME}"

mkdir -p "$HOME_DIR/.config" "$HOME_DIR/.local/share/nvim"

tar -C "$HOME_DIR" -xzf "$ARCHIVE"
printf 'Restored archive into: %s\n' "$HOME_DIR"
