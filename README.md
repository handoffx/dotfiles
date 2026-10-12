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

## Requirements

- tmux >= 3.7 (synchronized output, extended keys `csi-u`)
- WezTerm (nightly is fine)
- Neovim >= 0.12
- ComicShannsMono Nerd Font (installed via `.chezmoiexternal`; CJK falls back to Noto Sans CJK SC / PingFang SC / Microsoft YaHei)

## Theme

Catppuccin Mocha everywhere: WezTerm built-in scheme, a hand-written tmux status line
(`dot_config/tmux/catppuccin-mocha.conf`, no plugin manager), and catppuccin/nvim.
