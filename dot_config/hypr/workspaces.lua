-- Drives workspace name (Noctalia bar), monitor, layout, persistence, and
-- gaming/fullscreen perks for ws5. Replaces the exec-once
-- `hyprctl renameworkspace` chain and the workspace lines that used to be
-- split across hyprland.conf, monitors.conf, and windowrules.conf.
local NO_DECO = { gaps_in = 0, gaps_out = 0, no_border = true, no_rounding = true, no_shadow = true }

local workspaces = {
    { id =  1, name = "󰆍 terminal", monitor = "DP-1", layout = "scrolling", persistent = true },
    { id =  2, name = "󰖟 browser",  monitor = "DP-2",                       persistent = true },
    { id =  3, name = "󰨞 code",     monitor = "DP-1", layout = "scrolling", persistent = true },
    { id =  4, name = "󰭹 chat",     monitor = "DP-2", layout = "scrolling", persistent = true },
    { id =  5, name = "󰊗 games",    monitor = "DP-1",                       persistent = true, extras = NO_DECO },
    { id =  6, name = "󰒍 vault",    monitor = "DP-2", layout = "scrolling", persistent = true },
    { id =  7, name = "󰀻 misc",     monitor = "DP-2" },
    { id =  8, name = "󰀻 misc",     monitor = "DP-2" },
    { id =  9, name = "󰀻 misc",     monitor = "DP-2" },
    { id = 10, name = "󰀻 misc" },
}

for _, w in ipairs(workspaces) do
    local spec = {
        workspace    = tostring(w.id),
        default_name = w.name,
        monitor      = w.monitor,
        layout       = w.layout,
        persistent   = w.persistent,
    }
    if w.extras then
        for k, v in pairs(w.extras) do spec[k] = v end
    end
    hl.workspace_rule(spec)
end
