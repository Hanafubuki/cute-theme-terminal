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

if [[ ! -r /proc/version ]] || ! grep -qiE 'microsoft|wsl' /proc/version; then
  printf 'This installer must be run inside Ubuntu on WSL.\n' >&2
  exit 1
fi

for file in zshrc starship.toml; do
  [[ -f "$SCRIPT_DIR/$file" ]] || { printf 'Missing %s in %s\n' "$file" "$SCRIPT_DIR" >&2; exit 1; }
done

info "Installing Ubuntu dependencies"
run sudo apt-get update
run sudo apt-get install -y zsh curl git fzf bat unzip ca-certificates gnupg wget python3 zsh-autosuggestions zsh-syntax-highlighting

if ! command -v eza >/dev/null 2>&1; then
  if apt-cache show eza >/dev/null 2>&1; then
    run sudo apt-get install -y eza
  elif [[ "$DRY_RUN" == "1" ]]; then
    echo '[dry-run] add eza-community Debian repository and install eza'
  else
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/gierens.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main' | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt-get update
    sudo apt-get install -y eza
  fi
fi

if ! command -v starship >/dev/null 2>&1; then
  info "Installing Starship"
  if [[ "$DRY_RUN" == "1" ]]; then echo '[dry-run] install Starship'; else curl -sS https://starship.rs/install.sh | sh -s -- -y; fi
fi

if ! command -v zoxide >/dev/null 2>&1; then
  if apt-cache show zoxide >/dev/null 2>&1; then
    run sudo apt-get install -y zoxide
  elif [[ "$DRY_RUN" == "1" ]]; then
    echo '[dry-run] install zoxide using official installer'
  else
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi

if [[ ! -s "$HOME/.nvm/nvm.sh" ]]; then
  info "Installing NVM"
  if [[ "$DRY_RUN" == "1" ]]; then
    echo '[dry-run] install NVM v0.40.8 with PROFILE=/dev/null'
  else
    PROFILE=/dev/null bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh)"
  fi
fi

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

WINDOWS_USER=""
if command -v powershell.exe >/dev/null 2>&1; then
  WINDOWS_USER="$(powershell.exe -NoProfile -Command '[Environment]::UserName' 2>/dev/null | tr -d '\r' || true)"
elif command -v cmd.exe >/dev/null 2>&1; then
  WINDOWS_USER="$(cmd.exe /C 'echo %USERNAME%' 2>/dev/null | tr -d '\r' | tail -n 1 || true)"
fi

if [[ "$DRY_RUN" == "1" ]]; then
  echo "[dry-run] install and adapt $SCRIPT_DIR/zshrc -> $HOME/.zshrc"
  echo "[dry-run] install $SCRIPT_DIR/starship.toml -> $HOME/.config/starship.toml"
  [[ -n "$WINDOWS_USER" ]] && echo "[dry-run] substitute /mnt/c/Users/$WINDOWS_USER with ~ in Starship"
else
  cp "$SCRIPT_DIR/zshrc" "$HOME/.zshrc"
  cp "$SCRIPT_DIR/starship.toml" "$HOME/.config/starship.toml"
  python3 - "$HOME/.zshrc" <<'PY'
from pathlib import Path
import sys
path = Path(sys.argv[1])
s = path.read_text()
s = s.replace('[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \\. "/opt/homebrew/opt/nvm/nvm.sh"', '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"')
s = s.replace('source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh', 'source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh')
s = s.replace('source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh', 'source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh')
s = s.replace('# source /usr/share/doc/fzf/examples/key-bindings.zsh', '[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh')
s = s.replace('# source /usr/share/doc/fzf/examples/completion.zsh', '[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh')
if 'command -v bat >/dev/null' not in s:
    s = s.replace('alias cat="bat"', 'command -v bat >/dev/null 2>&1 || alias bat=batcat\nalias cat="bat"')
path.write_text(s)
PY
  if [[ -n "$WINDOWS_USER" && -d "/mnt/c/Users/$WINDOWS_USER" ]]; then
    cat >> "$HOME/.config/starship.toml" <<STARSHIP

[directory.substitutions]
"/mnt/c/Users/$WINDOWS_USER" = "~"
STARSHIP
  fi
fi

if command -v zsh >/dev/null 2>&1 && [[ "${SHELL:-}" != "$(command -v zsh)" ]]; then
  info "Setting zsh as the default shell"
  run chsh -s "$(command -v zsh)"
fi

configure_windows_terminal() {
  command -v powershell.exe >/dev/null 2>&1 || { warn "powershell.exe not available; skipping Windows Terminal setup."; return 0; }
  info "Adding Catppuccin Mocha to Windows Terminal"
  local localappdata
  localappdata="$(powershell.exe -NoProfile -Command '[Environment]::GetFolderPath("LocalApplicationData")' 2>/dev/null | tr -d '\r' || true)"
  if [[ -z "$localappdata" ]]; then warn "Could not locate Windows LocalAppData; see README_MANUAL_INSTALL.md."; return 0; fi
  local fragment_dir="/mnt/c${localappdata#C:}/Microsoft/Windows Terminal/Fragments/CuteTokyoTerminal"
  fragment_dir="${fragment_dir//\\//}"
  local fragment_file="$fragment_dir/theme.json"
  if [[ "$DRY_RUN" == "1" ]]; then
    echo "[dry-run] create Windows Terminal fragment at $fragment_file"
  else
    mkdir -p "$fragment_dir"
    cat > "$fragment_file" <<'JSON'
{
  "schemes": [{
    "name": "Catppuccin Mocha", "background": "#1E1E2E", "foreground": "#CDD6F4",
    "cursorColor": "#F5E0DC", "selectionBackground": "#585B70", "black": "#45475A",
    "red": "#F38BA8", "green": "#A6E3A1", "yellow": "#F9E2AF", "blue": "#89B4FA",
    "purple": "#F5C2E7", "cyan": "#94E2D5", "white": "#BAC2DE", "brightBlack": "#585B70",
    "brightRed": "#F38BA8", "brightGreen": "#A6E3A1", "brightYellow": "#F9E2AF",
    "brightBlue": "#89B4FA", "brightPurple": "#F5C2E7", "brightCyan": "#94E2D5",
    "brightWhite": "#A6ADC8"
  }]
}
JSON
  fi
  if ! powershell.exe -NoProfile -Command "Get-ItemProperty 'HKCU:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts' -ErrorAction SilentlyContinue | Out-String" 2>/dev/null | grep -qi 'JetBrainsMono'; then
    warn "JetBrainsMono Nerd Font is not detected on Windows. Install it once from https://www.nerdfonts.com/font-downloads, then select it in the Ubuntu Windows Terminal profile."
  fi
}
configure_windows_terminal

info "Installation complete"
printf '\nClose Windows Terminal completely and open it again. New Ubuntu shells should start with zsh and the theme.\n'
printf 'If the Nerd Font is not installed, follow README_MANUAL_INSTALL.md for that one Windows-side step.\n'
printf 'Your previous config was preserved with a .backup-%s suffix when present.\n' "$TIMESTAMP"
