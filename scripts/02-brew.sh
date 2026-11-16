#!/usr/bin/env bash
# Homebrew + Brewfile.
set -euo pipefail
source "$(dirname "$0")/lib.sh"

if ! command -v brew >/dev/null 2>&1; then
  info "Instalando Homebrew…"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$("$BREW_PREFIX/bin/brew" shellenv)"
fi
ok "Homebrew $(brew --version | head -1 | awk '{print $2}')"

info "brew bundle…"
brew_bundle "$DOTFILES/Brewfile"
ok "Brewfile aplicado"
