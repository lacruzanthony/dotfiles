# Navegación
alias dots='cd "$DOTFILES"'
alias reload='exec zsh'

# Sustitutos modernos
if command -v eza >/dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -l --icons --git --group-directories-first'
  alias la='eza -la --icons --git --group-directories-first'
  alias lt='eza --tree --level=2 --icons'
fi
command -v bat >/dev/null && alias cat='bat --paging=never'

# Git
alias g='git'
alias lg='lazygit'
alias gst='git status -sb'

# Varios
alias brewup='brew update && brew upgrade && brew cleanup'
alias ports='lsof -iTCP -sTCP:LISTEN -n -P'
