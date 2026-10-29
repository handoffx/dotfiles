-- Catppuccin colorscheme, kept in sync with tmux (~/.config/tmux/conf.d/40-theme.conf)
-- If you change the flavour here, also change @catppuccin_flavor in tmux.

---@type LazySpec
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
    },
  },
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
