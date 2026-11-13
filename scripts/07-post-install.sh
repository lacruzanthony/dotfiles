#!/usr/bin/env bash
# Restaura config de apps, crea la identidad git local e instala plugins de Claude Code.
set -euo pipefail
source "$(dirname "$0")/lib.sh"

# --- Apps que reescriben su config (se copian, no se enlazan) ---
info "T3 Code"
copy_if_changed "$DOTFILES/apps/t3code/client-settings.json" "$HOME/.t3/userdata/client-settings.json"
copy_if_changed "$DOTFILES/apps/t3code/keybindings.json"     "$HOME/.t3/userdata/keybindings.json"

info "Rectangle"
RECT="$DOTFILES/apps/rectangle/RectangleConfig.json"
if [ -f "$RECT" ]; then
  # Rectangle importa este archivo al arrancar.
  copy_if_changed "$RECT" "$HOME/Library/Application Support/Rectangle/RectangleConfig.json"
  pgrep -x Rectangle >/dev/null && { killall Rectangle; open -a Rectangle; } || true
else
  warn "Sin apps/rectangle/RectangleConfig.json: expórtalo desde Rectangle → Settings → Export"
fi

# --- Identidad git (nunca en el repo) ---
info "git: ~/.gitconfig.local"
if [ -f "$HOME/.gitconfig.local" ]; then
  ok "~/.gitconfig.local ya existe"
elif [ -t 0 ]; then
  read -r -p "  Nombre para git: " git_name
  read -r -p "  Email personal: " git_personal
  read -r -p "  Email de trabajo (para ~/Documents/code/): " git_work
  sed -e "s|__NAME__|$git_name|" -e "s|__EMAIL__|$git_personal|" \
    "$DOTFILES/templates/gitconfig.local.example" > "$HOME/.gitconfig.local"
  sed -e "s|__EMAIL__|$git_work|" \
    "$DOTFILES/templates/gitconfig.work.example" > "$HOME/.gitconfig.work"
  ok "~/.gitconfig.local y ~/.gitconfig.work creados"
else
  warn "Sin terminal interactiva: copia templates/gitconfig.*.example a ~ a mano"
fi

# --- Plugins de Claude Code ---
info "Claude Code plugins"
if command -v claude >/dev/null 2>&1; then
  grep -vE '^\s*(#|$)' "$DOTFILES/ai/claude/plugins.txt" | while read -r plugin; do
    claude plugin install "$plugin" >/dev/null 2>&1 && ok "$plugin" || warn "no se pudo instalar $plugin"
  done
else
  warn "claude no está en el PATH: salto plugins"
fi

# --- Varios ---
command -v bat >/dev/null 2>&1 && bat cache --build >/dev/null && ok "bat cache"
