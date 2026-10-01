#!/usr/bin/env bash
set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

info() { printf '\033[1;35m♡\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!\033[0m %s\n' "$*" >&2; }
run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '[dry-run]'; printf ' %q' "$@"; printf '\n'
  else
    "$@"
  fi
}

if [[ "$(uname -s)" != "Darwin" ]]; then
  printf 'This installer is for macOS. Use ./install-wsl.sh inside WSL.\n' >&2
  exit 1
fi

for file in zshrc starship.toml iterm-profile.json; do
  [[ -f "$SCRIPT_DIR/$file" ]] || { printf 'Missing %s in %s\n' "$file" "$SCRIPT_DIR" >&2; exit 1; }
done

if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew"
  if [[ "$DRY_RUN" == "1" ]]; then
    echo '[dry-run] install Homebrew from https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh'
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
fi

if [[ "$DRY_RUN" == "1" ]] && ! command -v brew >/dev/null 2>&1; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="$(brew --prefix)"
fi

info "Installing terminal tools"
run brew install bat eza fzf nvm starship zoxide zsh-autosuggestions zsh-syntax-highlighting
run brew install --cask iterm2 font-jetbrains-mono-nerd-font

mkdir -p "$HOME/.config"

backup_file() {
  local target="$1"
  if [[ -f "$target" ]]; then
    local backup="${target}.backup-${TIMESTAMP}"
    info "Backing up $target to $backup"
    run cp "$target" "$backup"
  fi
}

backup_file "$HOME/.zshrc"
backup_file "$HOME/.config/starship.toml"

if [[ "$DRY_RUN" == "1" ]]; then
  echo "[dry-run] install $SCRIPT_DIR/zshrc -> $HOME/.zshrc"
  echo "[dry-run] adapt NVM path to $BREW_PREFIX/opt/nvm/nvm.sh"
  echo "[dry-run] enable macOS fzf integration"
  echo "[dry-run] install $SCRIPT_DIR/starship.toml -> $HOME/.config/starship.toml"
else
  cp "$SCRIPT_DIR/zshrc" "$HOME/.zshrc"
  cp "$SCRIPT_DIR/starship.toml" "$HOME/.config/starship.toml"

  python3 - "$HOME/.zshrc" "$BREW_PREFIX" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
prefix = sys.argv[2]
s = path.read_text()
s = s.replace('/opt/homebrew/opt/nvm/nvm.sh', f'{prefix}/opt/nvm/nvm.sh')
s = s.replace('# source <(fzf --zsh)', 'source <(fzf --zsh)')
path.write_text(s)
PY
fi

run mkdir -p "$HOME/.nvm"

if [[ "$DRY_RUN" == "1" ]]; then
  echo "[dry-run] open $SCRIPT_DIR/iterm-profile.json"
else
  if ! open "$SCRIPT_DIR/iterm-profile.json" >/dev/null 2>&1; then
    warn "Could not open the iTerm2 profile automatically. Import it manually from iTerm2 Settings → Profiles."
  fi
fi

if command -v zsh >/dev/null 2>&1 && [[ "${SHELL:-}" != "$(command -v zsh)" ]]; then
  info "Setting zsh as the default shell"
  run chsh -s "$(command -v zsh)" "$USER"
fi

info "Installation complete"
printf '\nOpen a new iTerm2 window. If needed, select JetBrainsMono Nerd Font in iTerm2 → Settings → Profiles → Text.\n'
printf 'Your previous config was preserved with a .backup-%s suffix when present.\n' "$TIMESTAMP"
