# Cute Tokyo Terminal Theme

A soft pastel terminal setup built from **Zsh**, **Starship**, **Catppuccin-inspired colors**, and platform-specific terminal profiles. The prompt uses pink, lavender, blue, peach, and green accents, while Zsh syntax highlighting uses the same pastel palette.

The setup works on both:

- **macOS** with **iTerm2**
- **Windows 10/11** with **Windows Terminal + WSL2 + Ubuntu**

It also adds convenient command-line replacements and navigation helpers such as `eza`, `bat`, `fzf`, and `zoxide`.

The intended prompt looks roughly like:

```text
♡ ~/Projects/my-project  main
❯
```

## What’s included

- **`zshrc`** — Zsh startup settings. It initializes NVM, Starship, autosuggestions, syntax highlighting, and zoxide; adds `ls`, `ll`, and `cat` aliases; and colors commands, options, strings, paths, and unknown tokens.
- **`starship.toml`** — the two-line prompt: a heart, the current directory, Git branch and status, and a pastel prompt arrow. It also defines language symbols for Node.js, PHP, and Python when those runtimes are detected.
- **`iterm-profile.json`** — an iTerm2 profile named **Default**, with a pale background and pastel ANSI colors.
- **`Brewfile`** — Homebrew packages and a font used by this setup. It also lists optional tools and services such as CocoaPods, Apache, MySQL, Neovim, and PHP.

## How the setup is structured

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

## Requirements

### Mac

- macOS with Zsh and [Homebrew](https://brew.sh/)
- [iTerm2](https://iterm2.com/) for the included terminal color profile
- A [Nerd Font](https://www.nerdfonts.com/) for the symbols to display correctly; the Brewfile installs JetBrainsMono Nerd Font

The shell prompt configuration itself can also be used in other terminal emulators.

The `zshrc` currently uses Homebrew’s Apple Silicon path for NVM:

```text
/opt/homebrew/opt/nvm
```

On an Intel Mac, adjust that path to the location returned by:

```sh
brew --prefix nvm
```

### Windows

Use **Windows 10/11 with WSL2 and Ubuntu** to run this Zsh configuration.

Install WSL from an Administrator PowerShell window with:

```powershell
wsl --install
```

Restart if prompted, launch Ubuntu, and create your Linux user.

Install [Windows Terminal](https://aka.ms/terminal) for the terminal window.

The included iTerm2 profile is macOS-only. Windows Terminal uses its own profile and color-scheme settings.

A Nerd Font must be installed on **Windows itself**, not only inside WSL. The shell tools and plugins must be installed inside Ubuntu/WSL.

# Installation — macOS

## 1. Clone the repository

```sh
git clone https://github.com/Hanafubuki/cute-theme-terminal.git
cd cute-theme-terminal
```

## 2. Install dependencies

To install everything listed in the Brewfile, including optional tools and services:

```sh
brew bundle
```

If you only want the terminal setup:

```sh
brew install bat eza fzf nvm starship zoxide zsh-autosuggestions zsh-syntax-highlighting
brew install --cask font-jetbrains-mono-nerd-font
```

NVM manages Node.js versions but does not install Node by itself.

To install the latest LTS version of Node.js and Corepack:

```sh
nvm install --lts
npm install --global corepack
```

## 3. Install the configuration files

Back up your existing Zsh configuration first:

```sh
mkdir -p ~/.config
[ ! -f ~/.zshrc ] || cp ~/.zshrc ~/.zshrc.backup
```

Then copy the theme files:

```sh
cp zshrc ~/.zshrc
cp starship.toml ~/.config/starship.toml
```

Review `.zshrc.backup` if your previous configuration contains settings you want to preserve.

## 4. Configure iTerm2

Import the included profile:

**iTerm2 → Settings → Profiles → Other Actions → Import JSON Profiles**

Select:

```text
iterm-profile.json
```

Then select the imported profile or make it your default profile.

The file is a single iTerm2 profile rather than a Dynamic Profiles wrapper.

## 5. Select the Nerd Font

In iTerm2:

**Settings → Profiles → Text → Font**

Select:

```text
JetBrainsMono Nerd Font
```

A font size around `13–14` works well.

## 6. Reload Zsh

```sh
source ~/.zshrc
```

# Installation — Windows / WSL2 + Ubuntu

## 1. Install WSL2

Open **Administrator PowerShell** and run:

```powershell
wsl --install
```

Restart Windows if requested, then open Ubuntu and create your Linux user.

## 2. Install the base packages

Inside Ubuntu:

```sh
sudo apt update
sudo apt install -y zsh curl git fzf bat zsh-autosuggestions zsh-syntax-highlighting
```

Depending on your Ubuntu version, `eza` and `zoxide` may also be available directly:

```sh
sudo apt install -y eza zoxide
```

If `eza` is unavailable through APT, follow the [official eza Debian/Ubuntu installation instructions](https://github.com/eza-community/eza/blob/main/INSTALL.md#debian-and-ubuntu).

## 3. Make Zsh your default shell

```sh
chsh -s $(which zsh)
```

Close the terminal and reopen it.

Verify:

```sh
echo $SHELL
```

Expected output:

```text
/usr/bin/zsh
```

If `zsh-newuser-install` appears, choose:

```text
0
```

This creates a minimal `~/.zshrc` and prevents the setup wizard from appearing again.

## 4. Install Starship

```sh
curl -sS https://starship.rs/install.sh | sh
```

## 5. Install zoxide

If you did not install it with APT:

```sh
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

## 6. Install NVM

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | PROFILE=/dev/null bash
```

NVM should use Linux paths in WSL:

```sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
```

## 7. Clone the theme

Clone the repository inside Ubuntu:

```sh
git clone https://github.com/Hanafubuki/cute-theme-terminal.git
cd cute-theme-terminal
```

Create the Starship config directory:

```sh
mkdir -p ~/.config
```

Then copy the configuration files:

```sh
cp zshrc ~/.zshrc
cp starship.toml ~/.config/starship.toml
```

## 8. Adjust `.zshrc` for Ubuntu

The macOS version uses Homebrew paths. In WSL, use the Linux plugin paths instead.

Replace the macOS autosuggestions line with:

```sh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
```

Replace the macOS syntax-highlighting line with:

```sh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

For NVM, use:

```sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
```

### Ubuntu `bat` note

Ubuntu may install `bat` as `batcat`.

If this does not work:

```sh
bat --version
```

but this does:

```sh
batcat --version
```

add this before the `cat` alias:

```sh
alias bat=batcat
```

## 9. Configure fzf on WSL

Older Ubuntu versions of `fzf` may not support:

```sh
source <(fzf --zsh)
```

If you see:

```text
unknown option: --zsh
```

use the packaged Ubuntu integration instead:

```sh
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
```

Check that these files exist first:

```sh
ls /usr/share/doc/fzf/examples/
```

## 10. Configure zoxide

For normal `cd` plus smart navigation with `z`:

```sh
eval "$(zoxide init zsh)"
```

Then you can use:

```sh
cd ~/Projects
z dashboard
zi
```

`z` jumps to frequently used directories and `zi` opens an interactive fuzzy directory selector when `fzf` is available.

Do not initialize zoxide twice. Avoid using both:

```sh
eval "$(zoxide init zsh)"
eval "$(zoxide init zsh --cmd cd)"
```

Choose one mode.

## 11. Recommended WSL `.zshrc`

A clean WSL-specific version looks like this:

```sh
# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Starship
eval "$(starship init zsh)"

# Better CLI tools
alias ls="eza --icons"
alias ll="eza -lah --icons --git --group-directories-first"

# Ubuntu may expose bat as batcat
command -v bat >/dev/null 2>&1 || alias bat=batcat
alias cat="bat"

# Smart directory navigation
eval "$(zoxide init zsh)"

# FZF
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh

# Autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Catppuccin-style syntax colors
ZSH_HIGHLIGHT_STYLES[command]='fg=#f5c2e7,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#cba6f7,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#cba6f7,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[path]='fg=#89b4fa,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8,bold'
```

Reload it with:

```sh
source ~/.zshrc
```

# Starship configuration

Starship reads:

```text
~/.config/starship.toml
```

A minimal matching configuration looks like:

```toml
format = """
[♡](bold #f5c2e7) $directory$git_branch$git_status
[❯](bold #cba6f7) """

[directory]
format = "[$path]($style) "
style = "bold #89b4fa"
truncation_length = 0
truncate_to_repo = false

[git_branch]
symbol = " "
format = "[$symbol$branch]($style) "
style = "bold #f5c2e7"

[git_status]
format = "[$all_status$ahead_behind]($style) "
style = "bold #fab387"
```

This produces a prompt similar to:

```text
♡ ~/Projects/my-project  main
❯
```

## WSL path customization

WSL normally displays Windows paths like:

```text
/mnt/c/Users/Michele/Projects/my-project
```

To display this instead:

```text
~/Projects/my-project
```

add this to `starship.toml`:

```toml
[directory.substitutions]
"/mnt/c/Users/Michele" = "~"
```

This only changes how the path is displayed. The actual filesystem path is unchanged.

# Syntax highlighting

The Zsh highlighting configuration uses a Catppuccin-inspired pastel palette.

```sh
# Commands: git, npm, php, docker...
ZSH_HIGHLIGHT_STYLES[command]='fg=#f5c2e7,bold'

# Built-ins: cd, echo, source...
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#cba6f7,bold'

# Aliases: ll, ls...
ZSH_HIGHLIGHT_STYLES[alias]='fg=#cba6f7,bold'

# Options: -la, --force, --verbose
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fab387'

# Strings
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#a6e3a1'

# Paths
ZSH_HIGHLIGHT_STYLES[path]='fg=#89b4fa,underline'

# Invalid commands
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8,bold'
```

For example:

```sh
git commit -m "Fix login"
```

can display:

- `git` in pink
- `-m` in peach
- `"Fix login"` in green

The highlighting style definitions should come **after** `zsh-syntax-highlighting` is sourced.

# Catppuccin-inspired palette

| Purpose | Color | Hex |
| --- | --- | --- |
| Pink | Pink | `#F5C2E7` |
| Purple | Mauve | `#CBA6F7` |
| Red | Red | `#F38BA8` |
| Peach | Peach | `#FAB387` |
| Yellow | Yellow | `#F9E2AF` |
| Green | Green | `#A6E3A1` |
| Teal | Teal | `#94E2D5` |
| Blue | Blue | `#89B4FA` |
| Lavender | Lavender | `#B4BEFE` |
| Foreground | Text | `#CDD6F4` |
| Background | Base | `#1E1E2E` |

# Catppuccin in iTerm2

The included `iterm-profile.json` already provides the repository's iTerm2 profile.

If you want to import Catppuccin separately, use the official [Catppuccin iTerm repository](https://github.com/catppuccin/iterm).

Import a `.itermcolors` file and select it under:

**iTerm2 → Settings → Profiles → Colors → Color Presets**

Catppuccin variants include:

- Latte
- Frappé
- Macchiato
- Mocha

# Catppuccin Mocha in Windows Terminal

Windows Terminal controls the background and ANSI palette separately from Starship and Zsh.

Open:

**Windows Terminal → Settings → Open JSON file**

Add this object inside the top-level `"schemes"` array:

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

Then select it under:

**Windows Terminal → Settings → Profiles → Ubuntu → Appearance → Color scheme → Catppuccin Mocha**

# Nerd Font on Windows

The Nerd Font must be installed on **Windows**, because Windows Terminal performs the rendering.

Download **JetBrainsMono Nerd Font** from [Nerd Fonts](https://www.nerdfonts.com/font-downloads).

Install at least:

```text
JetBrainsMonoNerdFont-Regular.ttf
JetBrainsMonoNerdFont-Bold.ttf
JetBrainsMonoNerdFont-Italic.ttf
JetBrainsMonoNerdFont-BoldItalic.ttf
```

Then completely close and reopen Windows Terminal.

Go to:

**Windows Terminal → Settings → Profiles → Ubuntu → Appearance → Font face**

Choose:

```text
JetBrainsMono Nerd Font
```

If the font is not listed, check:

**Windows Settings → Personalization → Fonts**

and confirm JetBrains Mono Nerd Font is installed.

You can test Nerd Font rendering from WSL with:

```sh
printf '\ue5ff  \uf121  \uf07c  \ue73d  \uf1c9\n'
```

# Useful commands

## Better directory listing

```sh
ll
```

Equivalent to:

```sh
eza -lah --icons --git --group-directories-first
```

The output includes file-type icons when a Nerd Font is configured correctly.

## Smart directory navigation

Normal navigation still works:

```sh
cd ~/Projects
```

After zoxide learns your frequently used directories, you can use:

```sh
z dashboard
```

instead of typing a long path such as:

```sh
cd /mnt/c/Users/Michele/Projects/my-personal-dashboard
```

Interactive fuzzy navigation:

```sh
zi
```

## Fuzzy command history

Press:

```text
Ctrl + R
```

`fzf` provides interactive fuzzy history search when its Zsh integration is loaded.

# How the pieces work together

Zsh reads:

```text
~/.zshrc
```

when an interactive shell starts.

That file loads the plugins and initializes Starship and zoxide, then defines aliases and syntax colors.

Starship reads:

```text
~/.config/starship.toml
```

and renders the prompt, including the current directory and Git information.

iTerm2 or Windows Terminal controls the terminal's background, foreground, cursor, and ANSI colors. These terminal-level colors are separate from Starship's prompt colors and Zsh's syntax-highlighting colors.

# Customization

- Edit `starship.toml` to change the prompt layout, symbols, path behavior, or prompt colors.
- Edit `ZSH_HIGHLIGHT_STYLES` in `zshrc` to change syntax colors.
- Change terminal background and ANSI colors in iTerm2 or Windows Terminal.
- The `ll` alias uses eza's long, all-files, Git-aware view and groups directories first.
- `ls` uses eza with icons.
- `cat` uses bat.
- `z` and `zi` use zoxide for faster directory navigation.

# Saving and reusing the setup

This repository is already designed to act as a portable dotfiles-style setup.

The important files are:

```text
cute-theme-terminal/
├── README.md
├── zshrc
├── starship.toml
├── Brewfile
└── iterm-profile.json
```

On macOS, you can regenerate a Brewfile from your currently installed packages with:

```sh
brew bundle dump --file=Brewfile --force
```

Before committing `.zshrc` or other shell configuration, make sure it does not contain API keys, passwords, tokens, or other secrets.
