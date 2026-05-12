-- Hyprland 0.55+ Lua config.
-- Each require() runs in its own lua scope, so errors in one module
-- do not abort the others.

require("monitors")
require("environment")
require("appearance")
require("workspaces")
require("autostart")
require("keybinds")
require("windowrules")
