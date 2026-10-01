# Cute Tokyo Terminal Theme — Manual Installation

This is the manual installation guide for the Cute Tokyo Terminal Theme. For the automated installers, see [`README.md`](README.md).

A soft pastel terminal setup built from **Zsh**, **Starship**, **Catppuccin-inspired colors**, and platform-specific terminal profiles.

The setup works on:

- **macOS** with **iTerm2**
- **Windows 10/11** with **Windows Terminal + WSL2 + Ubuntu**

The intended prompt looks roughly like:

```text
♡ ~/Projects/my-project  main
❯
```

## What's included

- **`zshrc`** — Zsh startup settings, NVM, Starship, autosuggestions, syntax highlighting, zoxide, aliases and pastel syntax colors.
- **`starship.toml`** — two-line prompt with the current directory, Git branch/status, and runtime symbols.
- **`iterm-profile.json`** — the iTerm2 profile used on macOS.
- **`Brewfile`** — Homebrew dependencies and optional development tools.

## Architecture

### macOS

```text
iTerm2
  └── zsh
       ├── Starship
       ├── zsh-autosuggestions
       ├── zsh-syntax-highlighting
       ├── fzf
       ├── zoxide
       ├── eza
       └── bat
```

### Windows

```text
Windows Terminal
  └── Ubuntu / WSL2
       └── zsh
            ├── Starship
            ├── zsh-autosuggestions
            ├── zsh-syntax-highlighting
            ├── fzf
            ├── zoxide
            ├── eza
            └── bat
```

# Manual installation — macOS

## Requirements

- macOS with Zsh
- [Homebrew](https://brew.sh/)
- [iTerm2](https://iterm2.com/)
- JetBrainsMono Nerd Font

## 1. Clone the repository

```sh
git clone https://github.com/Hanafubuki/cute-theme-terminal.git
cd cute-theme-terminal
```

## 2. Install dependencies

Install everything from the Brewfile:

```sh
brew bundle
```

Or install only the terminal dependencies:

```sh
brew install bat eza fzf nvm starship zoxide zsh-autosuggestions zsh-syntax-highlighting
brew install --cask iterm2 font-jetbrains-mono-nerd-font
```

NVM manages Node.js versions but does not install Node itself. To install Node LTS and Corepack:

```sh
nvm install --lts
npm install --global corepack
```

## 3. Back up and install the configuration

```sh
mkdir -p ~/.config
[ ! -f ~/.zshrc ] || cp ~/.zshrc ~/.zshrc.backup
[ ! -f ~/.config/starship.toml ] || cp ~/.config/starship.toml ~/.config/starship.toml.backup
cp zshrc ~/.zshrc
cp starship.toml ~/.config/starship.toml
```

The repository `zshrc` uses the Apple Silicon Homebrew NVM path by default:

```text
/opt/homebrew/opt/nvm/nvm.sh
```

On Intel Macs, replace it with the path under:

```sh
brew --prefix nvm
```

## 4. Enable fzf on macOS

In `~/.zshrc`, enable:

```sh
source <(fzf --zsh)
```

## 5. Import the iTerm2 profile

Open:

**iTerm2 → Settings → Profiles → Other Actions → Import JSON Profiles**

Select:

```text
iterm-profile.json
```

Then select the imported profile or make it the default.

## 6. Select the Nerd Font

Open:

**iTerm2 → Settings → Profiles → Text → Font**

Select:

```text
JetBrainsMono Nerd Font
```

A size around 13–14 works well.

## 7. Reload Zsh

```sh
source ~/.zshrc
```

# Manual installation — Windows / WSL2 + Ubuntu

## 1. Install WSL

Open Administrator PowerShell:

```powershell
wsl --install
```

Restart Windows if requested, launch Ubuntu, and create the Linux user.

Install Windows Terminal if needed.

## 2. Install Ubuntu dependencies

Inside Ubuntu:

```sh
sudo apt update
sudo apt install -y zsh curl git fzf bat python3 zsh-autosuggestions zsh-syntax-highlighting
```

Install `eza` through APT if your Ubuntu version provides it:

```sh
sudo apt install eza
```

Otherwise use the [official eza Debian/Ubuntu instructions](https://github.com/eza-community/eza/blob/main/INSTALL.md#debian-and-ubuntu).

## 3. Set Zsh as the default shell

```sh
chsh -s $(which zsh)
```

Close and reopen the terminal.

Verify:

```sh
echo $SHELL
```

Expected:

```text
/usr/bin/zsh
```

If `zsh-newuser-install` appears, choose `0` to create a minimal `~/.zshrc`.

## 4. Install Starship

```sh
curl -sS https://starship.rs/install.sh | sh
```

## 5. Install zoxide

If it is available in APT:

```sh
sudo apt install zoxide
```

Otherwise:

```sh
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

## 6. Install NVM

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | PROFILE=/dev/null bash
```

Use Linux NVM paths in WSL:

```sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
```

## 7. Install the configuration

```sh
git clone https://github.com/Hanafubuki/cute-theme-terminal.git
cd cute-theme-terminal
mkdir -p ~/.config
cp zshrc ~/.zshrc
cp starship.toml ~/.config/starship.toml
```

Replace the Homebrew-specific plugin lines in `~/.zshrc` with:

```sh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

## 8. Configure bat

Ubuntu may expose `bat` as `batcat`. If so:

```sh
alias bat=batcat
alias cat="bat"
```

## 9. Configure fzf

Older Ubuntu packages may not support `fzf --zsh`. Use:

```sh
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
```

You can check the files first with:

```sh
ls /usr/share/doc/fzf/examples/
```

## 10. Configure zoxide

Keep normal `cd` and add smart navigation with:

```sh
eval "$(zoxide init zsh)"
```

Then use:

```sh
z dashboard
zi
```

Do not initialize zoxide twice with both the standard and `--cmd cd` modes.

## 11. Hide the Windows user path in Starship

To display:

```text
~/Projects/my-project
```

instead of:

```text
/mnt/c/Users/YourName/Projects/my-project
```

add to `~/.config/starship.toml`:

```toml
[directory.substitutions]
"/mnt/c/Users/YourName" = "~"
```

This only changes the displayed path.

# Starship configuration

Starship reads:

```text
~/.config/starship.toml
```

A matching prompt configuration is:

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

[git_status]
style = "bold yellow"
format = "[$all_status$ahead_behind]($style)"
```

# Syntax highlighting

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

# Catppuccin-inspired palette

| Color | Hex |
| --- | --- |
| Pink | `#F5C2E7` |
| Mauve | `#CBA6F7` |
| Red | `#F38BA8` |
| Peach | `#FAB387` |
| Yellow | `#F9E2AF` |
| Green | `#A6E3A1` |
| Teal | `#94E2D5` |
| Blue | `#89B4FA` |
| Lavender | `#B4BEFE` |
| Text | `#CDD6F4` |
| Base | `#1E1E2E` |

# Catppuccin Mocha in Windows Terminal

Windows Terminal controls its background and ANSI palette separately from Starship and Zsh.

Open:

**Windows Terminal → Settings → Open JSON file**

Add this object to the top-level `schemes` array:

```json
{
  "name": "Catppuccin Mocha",
  "background": "#1E1E2E",
  "foreground": "#CDD6F4",
  "cursorColor": "#F5E0DC",
  "selectionBackground": "#585B70",
  "black": "#45475A",
  "red": "#F38BA8",
  "green": "#A6E3A1",
  "yellow": "#F9E2AF",
  "blue": "#89B4FA",
  "purple": "#F5C2E7",
  "cyan": "#94E2D5",
  "white": "#BAC2DE",
  "brightBlack": "#585B70",
  "brightRed": "#F38BA8",
  "brightGreen": "#A6E3A1",
  "brightYellow": "#F9E2AF",
  "brightBlue": "#89B4FA",
  "brightPurple": "#F5C2E7",
  "brightCyan": "#94E2D5",
  "brightWhite": "#A6ADC8"
}
```

Then choose:

**Windows Terminal → Settings → Profiles → Ubuntu → Appearance → Color scheme → Catppuccin Mocha**

# Nerd Font on Windows

The Nerd Font must be installed on Windows because Windows Terminal performs the rendering.

Download **JetBrainsMono Nerd Font** from [Nerd Fonts](https://www.nerdfonts.com/font-downloads), extract it, and install the font files.

Then select:

**Windows Terminal → Settings → Profiles → Ubuntu → Appearance → Font face → JetBrainsMono Nerd Font**

Test icon rendering from WSL:

```sh
printf '\ue5ff  \uf121  \uf07c  \ue73d  \uf1c9\n'
```

# Useful commands

```sh
ll
```

uses:

```sh
eza -lah --icons --git --group-directories-first
```

`zoxide` examples:

```sh
z dashboard
zi
```

Use `Ctrl + R` for fuzzy command-history search when the fzf Zsh integration is enabled.

# How the pieces work together

- Zsh reads `~/.zshrc`.
- Starship reads `~/.config/starship.toml`.
- iTerm2 or Windows Terminal controls the terminal-level background, foreground, cursor, font, and ANSI palette.
- `zsh-syntax-highlighting` controls the colors of commands you type.
- `eza`, `bat`, `fzf`, and `zoxide` improve file listing, file viewing, fuzzy search, and directory navigation.

# Customization

- Edit `starship.toml` for prompt layout, symbols, paths, and prompt colors.
- Edit `ZSH_HIGHLIGHT_STYLES` in `zshrc` for command-line syntax colors.
- Change terminal-level colors in iTerm2 or Windows Terminal.
- `ll` is the long Git-aware eza view.
- `ls` uses eza with icons.
- `cat` uses bat.
- `z` and `zi` use zoxide.

Before committing `.zshrc` or other shell configuration, ensure it contains no API keys, passwords, tokens, or other secrets.
