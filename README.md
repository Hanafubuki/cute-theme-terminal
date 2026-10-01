# Cute Tokyo Terminal Theme

A soft pastel terminal setup built from Zsh, Starship, and an iTerm2 profile. The prompt uses pink and lavender accents, while Zsh syntax highlighting uses a matching pastel palette. The configuration also adds a few convenient command line replacements and directory navigation helpers.

## What’s included

- **`zshrc`** — Zsh startup settings. It initializes NVM, Starship, autosuggestions, syntax highlighting, and zoxide; adds `ls`, `ll`, and `cat` aliases; and colors commands, options, strings, paths, and unknown tokens.
- **`starship.toml`** — the two-line prompt: a heart, the current directory, Git branch and status, and a pink prompt arrow. It also defines language symbols for Node.js, PHP, and Python when those runtimes are detected.
- **`iterm-profile.json`** — an iTerm2 profile named **Default**, with a pale background and pastel ANSI colors.
- **`Brewfile`** — Homebrew packages and a font used by this setup. It also lists optional tools and services such as CocoaPods, Apache, MySQL, Neovim, and PHP.

## Requirements

- macOS with Zsh and [Homebrew](https://brew.sh/)
- [iTerm2](https://iterm2.com/) for the included terminal color profile (the shell prompt configuration can also be used in other terminal emulators)
- A [Nerd Font](https://www.nerdfonts.com/) for the symbols to display as intended; the Brewfile installs JetBrainsMono Nerd Font

The `zshrc` currently uses Homebrew’s Apple Silicon path for NVM (`/opt/homebrew/opt/nvm`). On an Intel Mac, adjust that path to the location returned by `brew --prefix nvm`.

## Installation

1. Clone this repository and enter its directory:

   ```sh
   git clone https://github.com/Hanafubuki/cute-theme-terminal.git
   cd cute-theme-terminal
   ```

2. Install the setup’s Homebrew dependencies. To install everything in the Brewfile, including its optional tools and services, run:

   ```sh
   brew bundle
   ```

   If you only want the terminal setup, install its core dependencies instead:

   ```sh
   brew install bat eza fzf nvm starship zoxide zsh-autosuggestions zsh-syntax-highlighting
   brew install --cask font-jetbrains-mono-nerd-font
   ```

   NVM manages Node.js versions but does not install Node by itself. If you want Node.js and Corepack, install an LTS release before installing Corepack:

   ```sh
   nvm install --lts
   npm install --global corepack
   ```

3. Back up your existing Zsh configuration, then install these files in the locations Zsh and Starship expect:

   ```sh
   mkdir -p ~/.config
   [ ! -f ~/.zshrc ] || cp ~/.zshrc ~/.zshrc.backup
   cp zshrc ~/.zshrc
   cp starship.toml ~/.config/starship.toml
   ```

   Review the existing `.zshrc` backup first if it contains settings you want to keep. The included `zshrc` enables the macOS `fzf` integration only as an optional commented line; uncomment it if desired. Windows users running Zsh should use the two fzf key-binding and completion lines shown in the file instead. The NVM initialization path in `zshrc` is set for Apple Silicon Macs; update it on Intel Macs as noted above.

4. In iTerm2, open **Settings → Profiles**, use **Other Actions → Import JSON Profiles**, and select `iterm-profile.json`. Then select the imported profile for your session or make it the default. The file is a single iTerm2 profile, rather than an iTerm2 Dynamic Profiles wrapper.

5. Restart the terminal or reload the shell configuration:

   ```sh
   source ~/.zshrc
   ```

## How the pieces work together

Zsh reads `~/.zshrc` when an interactive shell starts. That file loads the plugins and initializes Starship and zoxide, then defines aliases and syntax colors. Starship reads `~/.config/starship.toml` to render the prompt, including the current directory and Git information. iTerm2 supplies the background and terminal colors from the imported profile; those colors are separate from Starship’s prompt colors and Zsh’s syntax colors.

The prompt and syntax highlighting use several Catppuccin-like colors directly in their configuration, including pink (`#f5c2e7`), lavender (`#cba6f7`), blue (`#89b4fa`), yellow (`#f9e2af`), peach (`#fab387`), green (`#a6e3a1`), and red (`#f38ba8`).

## Customization

- Edit `starship.toml` to change the prompt layout, symbols, or prompt colors.
- Edit the `ZSH_HIGHLIGHT_STYLES` entries in `zshrc` to change syntax colors.
- Change terminal background and ANSI colors in iTerm2’s profile settings, then export the profile if you want to keep those changes in `iterm-profile.json`.
- The `ll` alias uses eza’s long, all-files, Git-aware view and groups directories first. `ls` uses eza with icons, and `cat` uses bat.
