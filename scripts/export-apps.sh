#!/usr/bin/env bash
# Copia la config actual de las apps (que no se pueden enlazar) de vuelta al repo.
# Lo ejecuta el pre-commit hook; también se puede lanzar a mano.
set -euo pipefail
source "$(dirname "$0")/lib.sh"

copy_if_changed "$HOME/.t3/userdata/client-settings.json" "$DOTFILES/apps/t3code/client-settings.json"
copy_if_changed "$HOME/.t3/userdata/keybindings.json"     "$DOTFILES/apps/t3code/keybindings.json"
