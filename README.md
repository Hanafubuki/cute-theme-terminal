# Cute Tokyo Terminal Theme

A soft pastel terminal setup built from **Zsh**, **Starship**, **Tokyo Starry Night**, Nerd Fonts, and a few quality-of-life CLI tools.

It supports:

- **macOS** with **iTerm2**
- **Windows 10/11** with **Windows Terminal + WSL2 + Ubuntu**

The intended prompt looks roughly like:

```text
♡ ~/Projects/my-project  main
❯
```

## What gets installed

The installers configure:

- Zsh
- Starship
- JetBrainsMono Nerd Font support
- zsh-autosuggestions
- zsh-syntax-highlighting
- eza
- bat
- fzf
- zoxide
- NVM
- **Tokyo Starry Night** terminal colors
- custom pastel Starship and Zsh syntax colors
- the repository's `zshrc`
- the repository's `starship.toml`

Existing `~/.zshrc` and `~/.config/starship.toml` files are backed up with a timestamp before replacement.

## macOS

Clone the repository:

```sh
git clone https://github.com/Hanafubuki/cute-theme-terminal.git
cd cute-theme-terminal
```

Run:

```sh
bash install-mac.sh
```

The installer will:

1. Install Homebrew if it is missing.
2. Install iTerm2.
3. Install JetBrainsMono Nerd Font.
4. Install Starship, eza, bat, fzf, zoxide, NVM, autosuggestions and syntax highlighting.
5. Back up existing terminal configuration.
6. Install `zshrc` and `starship.toml`.
7. Detect the Homebrew prefix so both Apple Silicon and Intel Macs work.
8. Enable the macOS fzf integration.
9. Open `iterm-profile.json`, which contains the Tokyo Starry Night-style iTerm2 profile.
10. Set Zsh as the default shell when needed.

After it finishes, open a new iTerm2 window. If the font was not selected automatically, choose:

**iTerm2 → Settings → Profiles → Text → JetBrainsMono Nerd Font**

## Windows / WSL2

If WSL is not installed yet, open Administrator PowerShell and run:

```powershell
wsl --install
```

Restart Windows if requested, then open Ubuntu.

Clone the repository inside WSL:

```sh
git clone https://github.com/Hanafubuki/cute-theme-terminal.git
cd cute-theme-terminal
```

Run:

```sh
bash install-wsl.sh
```

The installer will:

1. Verify that it is running inside WSL.
2. Install the required Ubuntu packages.
3. Install eza, Starship, zoxide and NVM when missing.
4. Install Zsh autosuggestions and syntax highlighting.
5. Back up existing terminal configuration.
6. Convert the shared macOS-oriented `zshrc` to WSL paths automatically.
7. Handle Ubuntu's `bat` / `batcat` difference.
8. Enable Ubuntu fzf key bindings and completion.
9. Set Zsh as the default shell.
10. Detect your Windows username and replace `/mnt/c/Users/<name>` with `~` in the displayed Starship path.
11. Add the **Tokyo Starry Night** color scheme to Windows Terminal through its fragment system when Windows integration is available.
12. Check whether JetBrainsMono Nerd Font is already installed on Windows.

The Windows scheme uses the Tokyo Night Storm palette:

```text
Background  #24283B
Foreground  #C0CAF5
Red         #F7768E
Green       #9ECE6A
Yellow      #E0AF68
Blue        #7AA2F7
Purple      #BB9AF7
Cyan        #7DCFFF
```

After installation, select:

**Windows Terminal → Settings → Profiles → Ubuntu → Appearance → Color scheme → Tokyo Starry Night**

If the Nerd Font is not installed on Windows, the installer will tell you. Install it once from [Nerd Fonts](https://www.nerdfonts.com/font-downloads), then select it under:

**Windows Terminal → Settings → Profiles → Ubuntu → Appearance → Font face**

After installation, completely close Windows Terminal and reopen it.

## Dry run

Both installers support a dry-run mode for inspecting what they would do without installing packages or replacing configuration:

```sh
DRY_RUN=1 bash install-mac.sh
```

or:

```sh
DRY_RUN=1 bash install-wsl.sh
```

## Useful commands
List all files and directories in alphabetical order, with the folders on top and with nice and colourful icons
```sh
ll
```

Shows a long, Git-aware directory listing with icons using eza.
```sh
z dashboard
```

Uses zoxide to jump to a previously visited directory.
```sh
zi
```

Git add, commit and push branch
```sh
gacp <commit message>
```

Git checkout main && git pull
```sh
gcp
```

opens an interactive fuzzy directory picker.

Press `Ctrl + R` for fuzzy command-history search with fzf.

## Theme layers

The terminal theme and shell colors are separate:

- **Tokyo Starry Night** controls the terminal background and ANSI palette in iTerm2 / Windows Terminal.
- **Starship** controls the heart, prompt arrow, directory, Git branch and Git status colors.
- **zsh-syntax-highlighting** controls command, option, string, path and error colors as you type.

This means you can change the Starship/Zsh pastel accents without changing the Tokyo Starry Night terminal background.

## Files

```text
cute-theme-terminal/
├── README.md
├── README_MANUAL_INSTALL.md
├── install-mac.sh
├── install-wsl.sh
├── zshrc
├── starship.toml
├── iterm-profile.json
├── tests/
│   └── test_installers.sh
└── Brewfile
```

## Manual installation

For the complete manual setup, troubleshooting steps, color definitions, Windows Terminal JSON, Nerd Font instructions, and individual package commands, see:

**[README_MANUAL_INSTALL.md](README_MANUAL_INSTALL.md)**

## Safety

Before committing your own modified `.zshrc`, make sure it does not contain API keys, passwords, tokens, or other secrets.
