#!/usr/bin/env bash
# Ejecuta los pasos de scripts/ en orden. Idempotente: se puede relanzar.
#   ./install.sh          → todos los pasos
#   ./install.sh 03 07    → solo los pasos indicados
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES

steps=("$@")
for script in "$DOTFILES"/scripts/[0-9][0-9]-*.sh; do
  name="$(basename "$script")"
  if [ ${#steps[@]} -gt 0 ]; then
    match=false
    for s in "${steps[@]}"; do [ "${name%%-*}" = "$s" ] && match=true; done
    $match || continue
  fi
  printf '\n\033[1;34m==> %s\033[0m\n' "$name"
  bash "$script"
done

printf '\n\033[1;32m✔ Listo.\033[0m Abre una terminal nueva. Pasos manuales: ver README.\n'
