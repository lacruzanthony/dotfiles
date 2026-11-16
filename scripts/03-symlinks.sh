#!/usr/bin/env bash
# Enlaza home/ → ~/ (archivo a archivo) y la config de IA de ai/ a cada agente.
set -euo pipefail
source "$(dirname "$0")/lib.sh"

info "home/ → ~/"
mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
chmod 600 "$DOTFILES/home/.ssh/config"   # ssh rechaza configs con permisos abiertos
cd "$DOTFILES/home"
find . \( -type f -o -type l \) ! -name '.DS_Store' -print0 | while IFS= read -r -d '' f; do
  rel="${f#./}"
  link "$DOTFILES/home/$rel" "$HOME/$rel"
done

info "ai/ → Claude Code y Codex"
# Una capa privada (~/.dotfiles-work) puede sustituir estos enlaces por versiones que
# amplían las públicas: si ya apuntan allí, no se pisan.
link_base() {
  case "$(readlink "$2" 2>/dev/null)" in
    "$HOME/.dotfiles-work/"*) ok "${2/#$HOME/~} (capa privada)" ;;
    *) link "$1" "$2" ;;
  esac
}

# Una sola fuente de instrucciones globales para todos los agentes.
link_base "$DOTFILES/ai/instructions/AGENTS.md" "$HOME/.claude/CLAUDE.md"
link_base "$DOTFILES/ai/instructions/AGENTS.md" "$HOME/.codex/AGENTS.md"
link_base "$DOTFILES/ai/claude/settings.json"   "$HOME/.claude/settings.json"
link "$DOTFILES/ai/codex/config.toml"      "$HOME/.codex/config.toml"

# Skills propias: cada carpeta de ai/skills se enlaza en ambos agentes.
# (~/.claude/skills/synced lo gestiona la organización: no se toca.)
for skill in "$DOTFILES"/ai/skills/*/; do
  [ -d "$skill" ] || continue
  name="$(basename "$skill")"
  link "${skill%/}" "$HOME/.claude/skills/$name"
  link "${skill%/}" "$HOME/.codex/skills/$name"
done

info "git hooks del repo"
git -C "$DOTFILES" config core.hooksPath .githooks
ok "core.hooksPath = .githooks"
