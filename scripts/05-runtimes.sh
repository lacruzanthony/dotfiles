#!/usr/bin/env bash
# Node (nvm), Python (pyenv), Java (sdkman). Sin `set -u`: nvm y sdkman no lo soportan.
set -eo pipefail
source "$(dirname "$0")/lib.sh"

# --- Node con nvm (instalado por brew) ---
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
if [ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ]; then
  source "$BREW_PREFIX/opt/nvm/nvm.sh"
  nvm install --lts --no-progress >/dev/null
  nvm alias default 'lts/*' >/dev/null
  ok "Node $(node --version) (lts por defecto)"
else
  warn "nvm no encontrado: ejecuta antes el paso 02"
fi

# --- Python con pyenv ---
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init - bash)"
  latest="$(pyenv latest -k 3)"
  if pyenv versions --bare | grep -qx "$latest"; then
    ok "Python $latest ya instalado"
  else
    info "Instalando Python $latest (tarda un poco)…"
    pyenv install -s "$latest"
  fi
  pyenv global "$latest"
  ok "Python global = $latest"
else
  warn "pyenv no encontrado: ejecuta antes el paso 02"
fi

# --- Java con sdkman ---
export SDKMAN_DIR="$HOME/.sdkman"
if [ ! -d "$SDKMAN_DIR" ]; then
  info "Instalando sdkman…"
  # rcupdate=false: el .zshrc del repo ya carga sdkman.
  curl -s "https://get.sdkman.io?rcupdate=false" | bash >/dev/null
fi
source "$SDKMAN_DIR/bin/sdkman-init.sh"
if [ -d "$SDKMAN_DIR/candidates/java/current" ]; then
  ok "Java ya instalado ($(basename "$(readlink "$SDKMAN_DIR/candidates/java/current")"))"
else
  info "Instalando Java (versión por defecto de sdkman)…"
  sdk install java < /dev/null
fi
