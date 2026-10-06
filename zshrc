export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
eval "$(starship init zsh)"
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Better CLI tools
alias ls="eza --icons"
alias ll="eza -lah --icons --git --group-directories-first"
alias cat="bat"
alias gcp="git checkout main && git pull"
gacp() {
  branch=$(git branch --show-current)
  git add . &&
  git commit -m "$*" &&
  git push -u origin "$branch"
}

# Smarter cd
eval "$(zoxide init zsh)"

# For MAC uncomment it
# source <(fzf --zsh)

#For Windows uncomment it
# source /usr/share/doc/fzf/examples/key-bindings.zsh
# source /usr/share/doc/fzf/examples/completion.zsh

# Syntax colors
ZSH_HIGHLIGHT_STYLES[command]='fg=#89b4fa,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f9e2af,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#89b4fa,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#89b4fa,bold'

ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fab387'

ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#a6e3a1'

ZSH_HIGHLIGHT_STYLES[path]='fg=#f5c2e7,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8,bold'
