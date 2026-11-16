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
# --adopt: si la app ya está en /Applications (instalada a mano), brew la adopta
# en vez de fallar con "It seems there is already an App".
HOMEBREW_CASK_OPTS="--adopt" brew bundle --file="$DOTFILES/Brewfile"
ok "Brewfile aplicado"
