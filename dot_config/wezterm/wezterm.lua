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
  -- GUI launches on macOS usually have no $SHELL; default to the system zsh there
  local shell = os.getenv("SHELL") or (platform.is_mac and "/bin/zsh" or "/bin/bash")
  config.set_environment_variables = { SHELL = shell } -- tmux picks its default-shell from $SHELL
  config.default_prog = {
    shell,
    "-lc",
    "command -v tmux >/dev/null && exec tmux new-session -A -s main || exec " .. shell .. " -l",
  }
end

return config
