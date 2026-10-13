# dotfiles

Cross-platform dotfiles managed with [chezmoi](https://www.chezmoi.io/):
WezTerm + tmux + Neovim ([lazyx-nvim](https://github.com/handoffx/lazyx-nvim)).

## Layout model

| Layer   | Role                                                                 |
|---------|----------------------------------------------------------------------|
| WezTerm | Renderer only. Owns `CTRL+SHIFT+*` (`SUPER+*` on macOS); no tabs or splits. |
| tmux    | Splits, windows, sessions (Linux / macOS). Prefix `C-a`.             |
| Neovim  | lazyx-nvim. `C-hjkl` / `M-hjkl` navigate / resize across nvim and tmux via smart-splits.nvim. |

Windows: native Neovim inside WezTerm, no tmux and no WezTerm splits.

## Key ownership

| Keys                        | Owner                                         |
|-----------------------------|-----------------------------------------------|
| `CTRL+SHIFT+c/v/f/p/r/l/n`  | WezTerm (copy, paste, search, palette, reload, debug, new window) |
| `CTRL+=/-/0`, `F11`         | WezTerm (font size, fullscreen)               |
| `C-h/j/k/l`                 | tmux root table; passed to nvim / fzf when they own the pane |
| `M-h/j/k/l`                 | tmux root table (resize 3 cells); passed to nvim when it owns the pane |
| `C-a` prefix                | tmux (`C-a C-a` sends a literal `C-a`, `C-a C-l` clears the shell) |

`at_edge = 'stop'` on both sides: navigation stops at the outermost pane.

## Install

```sh
# Linux / macOS
chezmoi init --apply handoffx

# Linux (this machine): use the working tree as the source directory
chezmoi init --source /workspace/debian/dotfiles --apply
```

`run_onchange_before_10-packages.sh` installs missing tools (`apt` on Debian, `brew` on macOS).
tmux, Neovim and ripgrep are expected to be installed separately on Linux.

`chezmoi init` asks two questions, stored in `~/.config/chezmoi/chezmoi.toml`
(change them later with `chezmoi edit-config`):

- `light`: light-use machine, only lua / python / web / data language groups (default `false`)
- `lazyxDevDir`: parent dir of a local lazyx-nvim checkout, loaded via lazy.nvim `dev`
  (empty: install from GitHub)

### macOS

Requires [Homebrew](https://brew.sh). The package script runs
`brew install neovim tmux git ripgrep fd fzf lazygit` and `brew install --cask wezterm@nightly`.

```sh
brew install chezmoi

# With a local checkout at ~/.config/dotfiles (and lazyx-nvim at ~/.config/lazyx-nvim)
chezmoi init --source ~/.config/dotfiles
chezmoi diff
chezmoi apply

# Non-interactive init: --promptBool / --promptString are keyed by the prompt text
chezmoi init --source ~/.config/dotfiles --no-tty \
  --promptBool 'Light-use machine (enable only a few languages)=false' \
  --promptString 'Parent dir of a local lazyx-nvim checkout (empty: install from GitHub)=/Users/<you>/.config'
```

Notes:

- The Nerd Font is extracted to `~/Library/Fonts/ComicShannsMono` and WezTerm reads it through
  `font_dirs`, because CoreText does not reliably expose it. Other apps may not see the font.
- CJK falls back to PingFang SC, then Hiragino Sans GB (PingFang is an on-demand asset on recent
  macOS that WezTerm may not find).
- `~/Library` and `~/.local` are kept at `0700`.
- macOS 26+ draws a translucent glass titlebar; WezTerm paints it with the terminal background via
  `MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR` (nightly only). Use `window_decorations = "RESIZE"`
  to drop the titlebar instead.
- WezTerm starts `tmux new-session -A -s main` from `$SHELL`, or `/bin/zsh` when a Dock launch has
  no `$SHELL`. The tmux server outlives WezTerm; run `tmux kill-server` to pick up shell changes.
- Run `nvim --headless "+Lazy! sync" +qa` to install plugins before the first interactive start.

## Requirements

- tmux >= 3.7 (synchronized output, extended keys `csi-u`)
- WezTerm (nightly; the macOS package script installs the `wezterm@nightly` cask)
- Neovim >= 0.12
- ComicShannsMono Nerd Font (installed via `.chezmoiexternal`; CJK falls back to Noto Sans CJK SC / PingFang SC, Hiragino Sans GB / Microsoft YaHei)

## Formatter fallbacks

- `~/.config/stylua/stylua.toml`: StyLua config for Lua files without a project config
  (2-space indents; StyLua's own default is tabs). Used through `--search-parent-directories`.

## Theme

Catppuccin Mocha everywhere: WezTerm built-in scheme, a hand-written tmux status line
(`dot_config/tmux/catppuccin-mocha.conf`, no plugin manager), and catppuccin/nvim.

Status lines use two-tone capsules (colored icon segment + surface0 text segment, rounded
`U+E0B6` / `U+E0B4` ends) on a transparent bar, in both tmux and Neovim. Both bars sit at the
bottom: Neovim's global statusline above tmux's. tmux right side: ZOOM / SYNC / COPY
indicators (only when active), directory, host, time. Floats and popups use rounded borders.

## License

[MIT](LICENSE)
