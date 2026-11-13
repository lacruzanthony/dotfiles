#!/usr/bin/env bash
# Command Line Tools: git, clang, make, python3…
set -euo pipefail
source "$(dirname "$0")/lib.sh"

if xcode-select -p >/dev/null 2>&1; then
  ok "Command Line Tools ya instaladas"
else
  info "Instalando Command Line Tools (acepta el diálogo)…"
  xcode-select --install || true
  until xcode-select -p >/dev/null 2>&1; do sleep 5; done
  ok "Command Line Tools instaladas"
fi
