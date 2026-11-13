#!/usr/bin/env bash
# Utilidades compartidas por los scripts de instalación (compatible con bash 3.2 de macOS).

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
BREW_PREFIX="/opt/homebrew"
[ -x "$BREW_PREFIX/bin/brew" ] && eval "$("$BREW_PREFIX/bin/brew" shellenv)"

info() { printf '  \033[34m→\033[0m %s\n' "$*"; }
ok()   { printf '  \033[32m✔\033[0m %s\n' "$*"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$*"; }

# link <origen> <destino>
#  - symlink ya correcto → no hace nada
#  - symlink a otro sitio → lo reapunta
#  - archivo/carpeta real → lo mueve a <destino>.bak (o .bak.<timestamp>)
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    if [ "$(readlink "$dst")" = "$src" ]; then
      ok "${dst/#$HOME/~}"
      return
    fi
    rm "$dst"
  elif [ -e "$dst" ]; then
    local bak="$dst.bak"
    [ -e "$bak" ] && bak="$dst.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$bak"
    warn "${dst/#$HOME/~} existía → ${bak/#$HOME/~}"
  fi
  ln -s "$src" "$dst"
  ok "${dst/#$HOME/~} → ${src/#$HOME/~}"
}

# copy_if_changed <origen> <destino>  (para apps que reescriben su config y rompen symlinks)
copy_if_changed() {
  local src="$1" dst="$2"
  [ -f "$src" ] || return 0
  mkdir -p "$(dirname "$dst")"
  if [ -f "$dst" ] && cmp -s "$src" "$dst"; then
    ok "${dst/#$HOME/~} (sin cambios)"
  else
    cp "$src" "$dst"
    ok "${dst/#$HOME/~} restaurado"
  fi
}
