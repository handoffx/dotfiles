local wezterm = require("wezterm")
local platform = require("platform")

local M = {}

function M.apply(config)
  config.color_scheme = "Catppuccin Mocha"

  -- ComicShannsMono has no CJK glyphs; fall back to the platform CJK font
  local cjk = (platform.is_mac and "PingFang SC") or (platform.is_win and "Microsoft YaHei") or "Noto Sans CJK SC"
  config.font = wezterm.font_with_fallback({ "ComicShannsMono Nerd Font", cjk })
  config.font_size = platform.is_mac and 14 or 12

  -- Renderer only: no tabs, splits belong to tmux (no splits at all on Windows)
  config.enable_tab_bar = false
  config.window_padding = { left = 4, right = 4, top = 2, bottom = 0 }
  config.adjust_window_size_when_changing_font_size = false
  config.audible_bell = "Disabled"

  config.enable_kitty_graphics = true
  config.max_fps = 120
end

return M
