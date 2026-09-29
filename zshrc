export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
eval "$(starship init zsh)"
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
alias ll="eza -lah --icons --git"

# Better CLI tools
alias ls="eza --icons"
alias ll="eza -lah --icons --git"
alias cat="bat"

# Smarter cd
eval "$(zoxide init zsh)"
source <(fzf --zsh)
