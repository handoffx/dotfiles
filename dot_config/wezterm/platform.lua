local wezterm = require("wezterm")

local triple = wezterm.target_triple

return {
  is_win = triple:find("windows") ~= nil,
  is_mac = triple:find("darwin") ~= nil,
  is_linux = triple:find("linux") ~= nil,
}
