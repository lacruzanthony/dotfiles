# Lo cargan todas las zsh, también las no interactivas (agentes, scripts, `zsh -c`).
# Así brew y sus herramientas están en el PATH aunque no se pase por .zprofile.
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
