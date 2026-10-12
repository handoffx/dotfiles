local wezterm = require("wezterm")
local platform = require("platform")

local config = wezterm.config_builder()

require("appearance").apply(config)
require("keys").apply(config)

if platform.is_win then
  local pwsh = wezterm.glob("C:/Program Files/PowerShell/7/pwsh.exe")[1]
  config.default_prog = pwsh and { pwsh, "-NoLogo" } or { "powershell.exe", "-NoLogo" }
else
  -- Attach to (or create) the tmux session "main"; fall back to a login shell without tmux
  local shell = os.getenv("SHELL") or "/bin/bash"
  config.default_prog = {
    shell,
    "-lc",
    "command -v tmux >/dev/null && exec tmux new-session -A -s main || exec " .. shell .. " -l",
  }
end

return config
