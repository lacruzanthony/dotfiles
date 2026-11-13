#!/usr/bin/env bash
# Oh My Zsh + plugins externos. El .zshrc viene de home/, así que no dejamos que OMZ lo sobrescriba.
set -euo pipefail
source "$(dirname "$0")/lib.sh"

ZSH_DIR="$HOME/.oh-my-zsh"
if [ -d "$ZSH_DIR" ]; then
  ok "Oh My Zsh ya instalado"
else
  info "Instalando Oh My Zsh…"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  ok "Oh My Zsh instalado"
fi

CUSTOM="${ZSH_CUSTOM:-$ZSH_DIR/custom}/plugins"
clone_plugin() {
  local name="$1" url="$2"
  if [ -d "$CUSTOM/$name" ]; then
    git -C "$CUSTOM/$name" pull --ff-only -q && ok "$name actualizado"
  else
    git clone -q --depth 1 "$url" "$CUSTOM/$name" && ok "$name instalado"
  fi
}
clone_plugin zsh-autosuggestions     https://github.com/zsh-users/zsh-autosuggestions
clone_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting
