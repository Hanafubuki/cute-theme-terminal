# Cute Tokyo Terminal Theme — Manual Installation

This is the manual installation guide for the Cute Tokyo Terminal Theme. For the automated installers, see [`README.md`](README.md).

The setup combines **Zsh**, **Starship**, **Tokyo Starry Night**, Nerd Fonts, and a pastel syntax-highlighting palette.

The terminal theme and shell colors are separate:

- **Tokyo Starry Night** controls the terminal background and ANSI palette.
- **Starship** controls the prompt, directory, Git branch and Git status colors.
- **zsh-syntax-highlighting** controls the colors of commands, options, strings, paths and invalid tokens.

The intended prompt looks roughly like:

```text
♡ ~/Projects/my-project  main
❯
```

## What's included

- `zshrc` — Zsh startup settings, NVM, Starship, autosuggestions, syntax highlighting, zoxide, aliases and pastel syntax colors.
- `starship.toml` — two-line prompt with current directory, Git branch/status and runtime symbols.
- `iterm-profile.json` — the iTerm2 profile used on macOS, with the Tokyo Starry Night-style terminal palette.
- `Brewfile` — Homebrew dependencies and optional development tools.

# Manual installation — macOS

## 1. Install dependencies

Install Homebrew from [brew.sh](https://brew.sh/) if needed, then:

```sh
brew install bat eza fzf nvm starship zoxide zsh-autosuggestions zsh-syntax-highlighting
brew install --cask iterm2 font-jetbrains-mono-nerd-font
```

## 2. Clone the repository

```sh
git clone https://github.com/Hanafubuki/cute-theme-terminal.git
cd cute-theme-terminal
```

## 3. Back up and install the config

```sh
mkdir -p ~/.config
[ ! -f ~/.zshrc ] || cp ~/.zshrc ~/.zshrc.backup
[ ! -f ~/.config/starship.toml ] || cp ~/.config/starship.toml ~/.config/starship.toml.backup
cp zshrc ~/.zshrc
cp starship.toml ~/.config/starship.toml
```

For NVM, use the path returned by:

```sh
brew --prefix nvm
```

Enable macOS fzf integration in `~/.zshrc`:

```sh
source <(fzf --zsh)
```

## 4. Import the iTerm2 profile

Open:

**iTerm2 → Settings → Profiles → Other Actions → Import JSON Profiles**

Select `iterm-profile.json`, then make the imported profile active/default.

Set the font under:

**iTerm2 → Settings → Profiles → Text → Font → JetBrainsMono Nerd Font**

Reload:

```sh
source ~/.zshrc
```

# Manual installation — Windows / WSL2 + Ubuntu

## 1. Install WSL

From Administrator PowerShell:

```powershell
wsl --install
```

Restart if requested, then open Ubuntu.

## 2. Install Ubuntu dependencies

```sh
sudo apt update
sudo apt install -y zsh curl git fzf bat python3 zsh-autosuggestions zsh-syntax-highlighting
```

Install `eza` and `zoxide` through APT when available:

```sh
sudo apt install -y eza zoxide
```

Otherwise use their official installation instructions.

Install Starship:

```sh
curl -sS https://starship.rs/install.sh | sh
```

Install NVM:

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | PROFILE=/dev/null bash
```

## 3. Use Zsh by default

```sh
chsh -s $(which zsh)
```

If `zsh-newuser-install` appears, choose `0`.

## 4. Install the repository config

```sh
git clone https://github.com/Hanafubuki/cute-theme-terminal.git
cd cute-theme-terminal
mkdir -p ~/.config
cp zshrc ~/.zshrc
cp starship.toml ~/.config/starship.toml
```

Replace macOS/Homebrew-specific plugin paths in `~/.zshrc` with:

```sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

Ubuntu may expose `bat` as `batcat`:

```sh
alias bat=batcat
alias cat="bat"
```

For older Ubuntu `fzf` packages, use:

```sh
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
```

Initialize zoxide once:

```sh
eval "$(zoxide init zsh)"
```

## 5. Hide the Windows user prefix in Starship

To display:

```text
~/Projects/my-project
```

instead of:

```text
/mnt/c/Users/YourName/Projects/my-project
```

add:

```toml
[directory.substitutions]
"/mnt/c/Users/YourName" = "~"
```

# Tokyo Starry Night — Windows Terminal

Windows Terminal controls the terminal-level background and ANSI palette separately from Zsh and Starship.

Open:

**Windows Terminal → Settings → Open JSON file**

Add this object to the top-level `schemes` array:

```json
{
  "name": "Tokyo Starry Night",
  "background": "#24283B",
  "foreground": "#C0CAF5",
  "cursorColor": "#C0CAF5",
  "selectionBackground": "#364A82",
  "black": "#1D202F",
  "red": "#F7768E",
  "green": "#9ECE6A",
  "yellow": "#E0AF68",
  "blue": "#7AA2F7",
  "purple": "#BB9AF7",
  "cyan": "#7DCFFF",
  "white": "#A9B1D6",
  "brightBlack": "#4E5575",
  "brightRed": "#F7768E",
  "brightGreen": "#9ECE6A",
  "brightYellow": "#E0AF68",
  "brightBlue": "#7AA2F7",
  "brightPurple": "#BB9AF7",
  "brightCyan": "#7DCFFF",
  "brightWhite": "#C0CAF5"
}
```

Then select:

**Windows Terminal → Settings → Profiles → Ubuntu → Appearance → Color scheme → Tokyo Starry Night**

The palette follows the Tokyo Night Storm colors used by the terminal profile.

# Nerd Font on Windows

Install **JetBrainsMono Nerd Font** on Windows from [Nerd Fonts](https://www.nerdfonts.com/font-downloads).

Then select:

**Windows Terminal → Settings → Profiles → Ubuntu → Appearance → Font face → JetBrainsMono Nerd Font**

Test icon rendering from WSL:

```sh
printf '\ue5ff  \uf121  \uf07c  \ue73d  \uf1c9\n'
```

# Starship prompt

Starship reads `~/.config/starship.toml`. The repository uses a soft pink/lavender prompt independently from the terminal theme:

```toml
format = """
[♡](bold #f5c2e7) $directory$git_branch$git_status
[❯](bold #f5c2e7) """

[directory]
truncation_length = 0
truncate_to_repo = false
style = "bold #cba6f7"
read_only = " 󰌾"
format = "[$path]($style) "

[git_branch]
symbol = " "
style = "bold #f5c2e7"
format = "[$symbol$branch]($style) "
```

# Zsh syntax colors

Place custom colors after loading `zsh-syntax-highlighting`:

```sh
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
```

These pastel shell colors are intentionally independent from Tokyo Starry Night, so you can customize them without changing the terminal background.

# Useful commands

```sh
ll
```

uses:

```sh
eza -lah --icons --git --group-directories-first
```

Zoxide examples:

```sh
z dashboard
zi
```

Use `Ctrl + R` for fuzzy command-history search when the fzf Zsh integration is enabled.

Before committing `.zshrc` or other shell configuration, ensure it contains no API keys, passwords, tokens, or other secrets.
