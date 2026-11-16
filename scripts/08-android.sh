#!/usr/bin/env bash
# OPCIONAL y último: Android Studio.
#   - ./install.sh 08          → lo instala sin preguntar
#   - ./install.sh (completo)  → pregunta; por defecto NO
#   - INSTALL_ANDROID=1 / 0    → fuerza sí / no (útil sin terminal interactiva)
set -euo pipefail
source "$(dirname "$0")/lib.sh"

want="${INSTALL_ANDROID:-}"
if [ -z "$want" ]; then
  if [ "${DOTFILES_EXPLICIT_STEPS:-0}" = 1 ]; then
    want=1
  elif [ -t 0 ]; then
    read -r -p "  ¿Instalar Android Studio? [y/N] " answer
    case "$answer" in [yYsS]*) want=1 ;; *) want=0 ;; esac
  else
    want=0
  fi
fi

if [ "$want" != 1 ]; then
  info "Android Studio omitido (instálalo luego con ./install.sh 08)"
  exit 0
fi

info "brew bundle (Android)…"
HOMEBREW_CASK_OPTS="--adopt" brew bundle --file="$DOTFILES/Brewfile.android"
ok "Android Studio instalado"
info "Ábrelo una vez para que el asistente descargue el SDK en ~/Library/Android/sdk"
info "(.zshrc ya exporta ANDROID_HOME y añade adb/emulator al PATH cuando existe)"
