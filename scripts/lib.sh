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

# brew_bundle <Brewfile>
# Como `brew bundle`, pero omite los casks cuya app ya existe en /Applications sin
# haberla instalado brew (adoptarlas exige sudo y falla). Esas apps se actualizan solas.
cask_app_present() {
  brew info --cask --json=v2 "$1" 2>/dev/null | python3 -I -c '
import json, os, sys
c = json.load(sys.stdin)["casks"][0]
apps = [a for art in c["artifacts"] for a in art.get("app", []) if isinstance(a, str)]
sys.exit(0 if apps and all(os.path.exists("/Applications/" + a) for a in apps) else 1)'
}

brew_bundle() {
  local brewfile="$1" filtered line cask
  filtered="$(mktemp)"
  while IFS= read -r line || [ -n "$line" ]; do
    if [[ $line =~ ^cask[[:space:]]+\"([^\"]+)\" ]]; then
      cask="${BASH_REMATCH[1]}"
      if ! brew list --cask "$cask" >/dev/null 2>&1 && cask_app_present "$cask"; then
        warn "$cask: ya está en /Applications (fuera de brew) → se omite" >&2
        continue
      fi
    fi
    printf '%s\n' "$line"
  done < "$brewfile" > "$filtered"
  local rc=0
  brew bundle --file="$filtered" || rc=$?
  rm -f "$filtered"
  return $rc
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
