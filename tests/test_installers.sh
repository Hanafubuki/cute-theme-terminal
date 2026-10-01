#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() { printf 'FAIL: %s\n' "$1" >&2; exit 1; }
assert_file() { [[ -f "$1" ]] || fail "missing file: $1"; }
assert_contains() { grep -Fq -- "$2" "$1" || fail "$1 missing: $2"; }
assert_not_contains() { ! grep -Fq -- "$2" "$1" || fail "$1 unexpectedly contains: $2"; }

assert_file "$ROOT/install-mac.sh"
assert_file "$ROOT/install-wsl.sh"
assert_file "$ROOT/README_MANUAL_INSTALL.md"

bash -n "$ROOT/install-mac.sh"
bash -n "$ROOT/install-wsl.sh"

assert_contains "$ROOT/install-mac.sh" 'DRY_RUN'
assert_contains "$ROOT/install-mac.sh" 'brew install'
assert_contains "$ROOT/install-mac.sh" 'font-jetbrains-mono-nerd-font'
assert_contains "$ROOT/install-mac.sh" 'starship.toml'
assert_contains "$ROOT/install-mac.sh" 'iterm-profile.json'

assert_contains "$ROOT/install-wsl.sh" 'DRY_RUN'
assert_contains "$ROOT/install-wsl.sh" '/proc/version'
assert_contains "$ROOT/install-wsl.sh" 'zsh-autosuggestions'
assert_contains "$ROOT/install-wsl.sh" 'starship.toml'
assert_contains "$ROOT/install-wsl.sh" 'powershell.exe'
assert_contains "$ROOT/install-wsl.sh" 'Tokyo Starry Night'
assert_contains "$ROOT/install-wsl.sh" '"background": "#24283B"'
assert_contains "$ROOT/install-wsl.sh" '"foreground": "#C0CAF5"'
assert_not_contains "$ROOT/install-wsl.sh" 'Catppuccin'
assert_contains "$ROOT/install-wsl.sh" 'JetBrainsMono Nerd Font'

assert_contains "$ROOT/README.md" 'Tokyo Starry Night'
assert_not_contains "$ROOT/README.md" 'Catppuccin'
assert_contains "$ROOT/README_MANUAL_INSTALL.md" 'Tokyo Starry Night'
assert_not_contains "$ROOT/README_MANUAL_INSTALL.md" 'Catppuccin'

printf 'All installer checks passed.\n'
