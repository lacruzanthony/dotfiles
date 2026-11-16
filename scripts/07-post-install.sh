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
  { grep -vE '^\s*(#|$)' "$DOTFILES/ai/claude/plugins.txt" || true; } | while read -r plugin; do
    claude plugin install "$plugin" >/dev/null 2>&1 && ok "$plugin" || warn "no se pudo instalar $plugin"
  done
else
  warn "claude no está en el PATH: salto plugins"
fi

# --- npm: redes corporativas lentas (menos descargas en paralelo, más paciencia) ---
# Va a ~/.npmrc, que no se versiona porque también guarda tokens.
info "npm"
export NVM_DIR="$HOME/.nvm"
[ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && { set +u; source "$BREW_PREFIX/opt/nvm/nvm.sh"; set -u; }
if command -v npm >/dev/null 2>&1; then
  npm config set maxsockets 4
  npm config set fetch-timeout 600000
  npm config set fetch-retries 5
  ok "maxsockets=4, fetch-timeout=10min, fetch-retries=5"
else
  warn "npm no encontrado: ejecuta antes el paso 05"
fi

# --- Docker: plugins de brew (compose, buildx) ---
# ~/.docker/config.json no se enlaza: docker/gcloud escriben ahí credenciales.
info "docker"
python3 -I - "$HOME/.docker/config.json" "$BREW_PREFIX/lib/docker/cli-plugins" <<'PY'
import json, os, sys
path, plugins = sys.argv[1], sys.argv[2]
os.makedirs(os.path.dirname(path), exist_ok=True)
cfg = json.load(open(path)) if os.path.exists(path) else {}
dirs = cfg.setdefault("cliPluginsExtraDirs", [])
if plugins not in dirs:
    dirs.append(plugins)
    json.dump(cfg, open(path, "w"), indent=2)
PY
ok "cliPluginsExtraDirs → docker compose / buildx"

# --- Varios ---
command -v bat >/dev/null 2>&1 && bat cache --build >/dev/null && ok "bat cache"
