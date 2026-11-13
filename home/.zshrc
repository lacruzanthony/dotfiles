# ~/.zshrc — gestionado desde ~/.dotfiles/home/.zshrc

export PATH="$HOME/.local/bin:$PATH"
export EDITOR="zed --wait"
export DOTFILES="$HOME/.dotfiles"

# --- Oh My Zsh (sin tema: el prompt es Starship) ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# --- Runtimes ---
export NVM_DIR="$HOME/.nvm"
[ -s /opt/homebrew/opt/nvm/nvm.sh ] && source /opt/homebrew/opt/nvm/nvm.sh
[ -s /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm ] && source /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null && eval "$(pyenv init - zsh)"

# --- Herramientas ---
command -v fzf      >/dev/null && source <(fzf --zsh)
command -v atuin    >/dev/null && eval "$(atuin init zsh)"     # Ctrl+R (va después de fzf)
command -v zoxide   >/dev/null && eval "$(zoxide init zsh)"
command -v starship >/dev/null && eval "$(starship init zsh)"

[ -f "$HOME/.config/zsh/aliases.zsh" ] && source "$HOME/.config/zsh/aliases.zsh"

# Config solo de esta máquina (no versionada)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# sdkman tiene que ir al final
export SDKMAN_DIR="$HOME/.sdkman"
[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
