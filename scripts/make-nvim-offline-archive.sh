#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: make-nvim-offline-archive.sh [output-archive.tar.gz]

Creates an offline Neovim archive that can be restored without Git access.

Included by default:
  ~/.config/nvim
  ~/.local/share/nvim/lazy
  ~/.local/share/nvim/mason
  ~/.local/share/nvim/site/parser
  ~/.local/share/nvim/site/parser-info

Optional state:
  Set NVIM_INCLUDE_STATE=1 to also include ~/.local/share/nvim/snacks and
  ~/.local/share/nvim/scratch.

Environment overrides:
  NVIM_HOME            Base home directory to archive from (default: $HOME)
  NVIM_CONFIG_DIR      Config directory (default: $HOME/.config/nvim)
  NVIM_DATA_DIR        Data directory (default: $HOME/.local/share/nvim)
  NVIM_INCLUDE_STATE   Include optional runtime state when set to 1
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

HOME_DIR="${NVIM_HOME:-$HOME}"
CONFIG_DIR="${NVIM_CONFIG_DIR:-$HOME_DIR/.config/nvim}"
DATA_DIR="${NVIM_DATA_DIR:-$HOME_DIR/.local/share/nvim}"
OUT_ARCHIVE="${1:-$HOME_DIR/nvim-offline-$(date +%Y%m%d-%H%M%S).tar.gz}"

if [[ ! -d "$CONFIG_DIR" ]]; then
  printf 'Config directory not found: %s\n' "$CONFIG_DIR" >&2
  exit 1
fi

if [[ ! -d "$DATA_DIR" ]]; then
  printf 'Data directory not found: %s\n' "$DATA_DIR" >&2
  exit 1
fi

paths=(
  ".config/nvim"
  ".local/share/nvim/lazy"
  ".local/share/nvim/mason"
  ".local/share/nvim/site/parser"
  ".local/share/nvim/site/parser-info"
)

if [[ "${NVIM_INCLUDE_STATE:-0}" == "1" ]]; then
  [[ -d "$DATA_DIR/snacks" ]] && paths+=(".local/share/nvim/snacks")
  [[ -d "$DATA_DIR/scratch" ]] && paths+=(".local/share/nvim/scratch")
fi

mkdir -p "$(dirname "$OUT_ARCHIVE")"

tar -C "$HOME_DIR" -czf "$OUT_ARCHIVE" "${paths[@]}"
printf 'Created archive: %s\n' "$OUT_ARCHIVE"
