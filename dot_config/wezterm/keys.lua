local wezterm = require("wezterm")
local platform = require("platform")

local act = wezterm.action
local M = {}

-- WezTerm only owns CTRL+SHIFT (SUPER on macOS); every other key passes through to tmux / nvim
local function bind(keys, key, action)
  if platform.is_mac then
    table.insert(keys, { key = key, mods = "SUPER", action = action })
  else
    table.insert(keys, { key = key, mods = "CTRL|SHIFT", action = action })
    table.insert(keys, { key = key:upper(), mods = "CTRL|SHIFT", action = action })
  end
end

function M.apply(config)
  config.disable_default_key_bindings = true

  -- macOS: left Option acts as Meta (M-hjkl resizes splits), right Option still composes characters
  config.send_composed_key_when_left_alt_is_pressed = false
  config.send_composed_key_when_right_alt_is_pressed = true

  local keys = {}
  bind(keys, "c", act.CopyTo("Clipboard"))
  bind(keys, "v", act.PasteFrom("Clipboard"))
  bind(keys, "f", act.Search("CurrentSelectionOrEmptyString"))
  bind(keys, "p", act.ActivateCommandPalette)
  bind(keys, "r", act.ReloadConfiguration)
  bind(keys, "l", act.ShowDebugOverlay)
  bind(keys, "n", act.SpawnWindow)

  local font_mod = platform.is_mac and "SUPER" or "CTRL"
  table.insert(keys, { key = "=", mods = font_mod, action = act.IncreaseFontSize })
  table.insert(keys, { key = "-", mods = font_mod, action = act.DecreaseFontSize })
  table.insert(keys, { key = "0", mods = font_mod, action = act.ResetFontSize })
  table.insert(keys, { key = "F11", action = act.ToggleFullScreen })

  if platform.is_mac then
    table.insert(keys, { key = "q", mods = "SUPER", action = act.QuitApplication })
    table.insert(keys, { key = "h", mods = "SUPER", action = act.HideApplication })
    table.insert(keys, { key = "m", mods = "SUPER", action = act.Hide })
  end

  config.keys = keys
end

return M
