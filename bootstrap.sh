#!/usr/bin/env bash
# Entrada remota:
#   curl -fsSL https://raw.githubusercontent.com/lacruzanthony/dotfiles/main/bootstrap.sh | bash
# Clona (o actualiza) el repo en ~/.dotfiles y lanza install.sh.
set -euo pipefail

REPO="https://github.com/lacruzanthony/dotfiles.git"
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# git viene con las Command Line Tools; sin ellas no podemos clonar.
if ! xcode-select -p >/dev/null 2>&1; then
  echo "→ Instalando Command Line Tools (acepta el diálogo de macOS)…"
  xcode-select --install || true
  until xcode-select -p >/dev/null 2>&1; do sleep 5; done
fi

if [ -d "$DOTFILES/.git" ]; then
  echo "→ Actualizando $DOTFILES"
  git -C "$DOTFILES" pull --ff-only
else
  echo "→ Clonando en $DOTFILES"
  git clone "$REPO" "$DOTFILES"
fi

exec "$DOTFILES/install.sh" "$@"
