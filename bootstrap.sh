#!/usr/bin/env bash
# Entrada remota:
#   curl -fsSL https://raw.githubusercontent.com/lacruzanthony/dotfiles/main/bootstrap.sh | bash
# Clona (o actualiza) el repo en ~/.dotfiles y lanza install.sh.
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# SSH si ya hay clave autorizada en GitHub (por el 443: el 22 suele estar bloqueado
# en redes corporativas); si no, HTTPS. En una máquina nueva lo normal es HTTPS.
REPO="https://github.com/lacruzanthony/dotfiles.git"
if ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new \
     -p 443 -T git@ssh.github.com 2>&1 | grep -q "successfully authenticated"; then
  REPO="git@github.com:lacruzanthony/dotfiles.git"
fi

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
