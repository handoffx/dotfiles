local wezterm = require("wezterm")
local platform = require("platform")

local M = {}

function M.apply(config)
  config.color_scheme = "Catppuccin Mocha"

  -- ComicShannsMono has no CJK glyphs; fall back to the platform CJK font
  -- (PingFang is an on-demand asset on recent macOS that WezTerm may not see; Hiragino Sans GB always ships)
  local cjk = (platform.is_mac and { "PingFang SC", "Hiragino Sans GB" })
    or (platform.is_win and { "Microsoft YaHei" })
    or { "Noto Sans CJK SC" }
  config.font = wezterm.font_with_fallback({ "ComicShannsMono Nerd Font", table.unpack(cjk) })
  if platform.is_mac then
    -- CoreText does not reliably expose the chezmoi-installed font; read it from disk
    config.font_dirs = { wezterm.home_dir .. "/Library/Fonts/ComicShannsMono" }
  end
  config.font_size = platform.is_mac and 14 or 12

  -- Renderer only: no tabs, splits belong to tmux (no splits at all on Windows)
  config.enable_tab_bar = false
  if platform.is_mac then
    -- macOS 26+ draws a translucent glass titlebar; paint it with the terminal background
    config.window_decorations = "TITLE | RESIZE | MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR"
  end
  config.window_padding = { left = 4, right = 4, top = 2, bottom = 0 }
  config.adjust_window_size_when_changing_font_size = false
  config.audible_bell = "Disabled"

  config.enable_kitty_graphics = true
  config.max_fps = 120
end

return M
