# Office, Teams, Zoom, Cisco, Chrome… los gestiona IT (Workspace ONE): no van aquí.

# --- Shell ---
brew "starship"            # prompt
brew "atuin"               # historial de shell en SQLite con búsqueda y sync
brew "fzf"                 # buscador difuso (Ctrl+T archivos)
brew "zoxide"              # `z carpeta` → cd inteligente

# --- Sustitutos modernos ---
brew "eza"                 # ls
brew "bat"                 # cat
brew "fd"                  # find
brew "ripgrep"             # grep
brew "jq"                  # JSON

# --- Git ---
brew "git"
brew "gh"                  # GitHub CLI
brew "git-delta"           # diffs bonitos
brew "lazygit"             # TUI de git

# --- Utilidades ---
brew "btop"                # monitor de sistema
brew "tlrc"                # `tldr <cmd>`: ejemplos rápidos
brew "httpie"              # `http` → curl legible

# --- Runtimes ---
brew "nvm"                 # Node
brew "pyenv"               # Python
brew "openssl@3"           # deps de compilación de Python (pyenv): sin openssl@3 instalado,
brew "readline"            #   pyenv prueba openssl@1.1 (ya no existe en brew) y suelta un error
brew "xz"                  #   inofensivo antes de caer en otra versión
brew "uv"                  # Python: proyectos con uv.lock (deps, venvs, scripts)
# sdkman (Java) no está en brew: lo instala scripts/05-runtimes.sh

# --- Contenedores (Docker sin Docker Desktop: sin licencia de pago) ---
brew "colima"              # VM ligera que da el motor de Docker: `colima start`
brew "docker"              # CLI de docker
brew "docker-compose"      # plugin `docker compose`
brew "docker-buildx"       # plugin `docker buildx`

# --- Apps ---
cask "rectangle"
cask "cmux"
cask "t3-code"
cask "zed"
# Android Studio es opcional: ver Brewfile.android y scripts/08-android.sh
cask "claude-code"
cask "codex"
cask "font-jetbrains-mono-nerd-font"   # iconos para starship/eza
