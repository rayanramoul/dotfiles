-- Noctalia writes its theme to a hyprlang .conf file. Lua's require() only
-- accepts .lua, and Hyprland's Lua API exposes no `source` for hyprlang
-- files, so we parse the `$var = value` lines ourselves on each config load.
-- Noctalia triggers `hyprctl reload` on theme changes, which re-runs this
-- file and picks up the new values.
local function read_noctalia_colors()
    local path = os.getenv("HOME") .. "/.config/hypr/noctalia/noctalia-colors.conf"
    local f = io.open(path, "r")
    if not f then return nil end
    local colors = {}
    for line in f:lines() do
        local k, v = line:match("^%$([%w_]+)%s*=%s*(.+)$")
        if k and v then colors[k] = v end
    end
    f:close()
    return colors
end

local fallback = {
    primary        = "rgb(ebbcba)",
    surface        = "rgb(191724)",
    secondary      = "rgb(9ccfd8)",
    error          = "rgb(eb6f92)",
    tertiary       = "rgb(31748f)",
    surface_lowest = "rgb(1b1928)",
}

local c = read_noctalia_colors() or {}
for k, v in pairs(fallback) do c[k] = c[k] or v end

hl.config({
    general = {
        gaps_in       = 5,
        gaps_out      = 10,
        border_size   = 2,
        layout        = "dwindle",
        allow_tearing = false,
        col = {
            active_border   = c.primary,
            inactive_border = c.surface,
        },
    },

    group = {
        col = {
            border_active          = c.secondary,
            border_inactive        = c.surface,
            border_locked_active   = c.error,
            border_locked_inactive = c.surface,
        },
        groupbar = {
            col = {
                active          = c.secondary,
                inactive        = c.surface,
                locked_active   = c.error,
                locked_inactive = c.surface,
            },
        },
    },

    scrolling = {
        column_width             = 0.5,
        fullscreen_on_one_column = true,
        follow_focus             = 1,
    },

    decoration = {
        rounding       = 20,
        rounding_power = 2,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
        blur = {
            enabled  = true,
            size     = 3,
            passes   = 2,
            vibrancy = 0.1696,
        },
    },

    cursor = {
        no_hardware_cursors = false,
    },

    animations = {
        enabled = true,
    },
})

-- 0.55-native physical spring for window animations. Mass / stiffness /
-- dampening values come from the upstream `easy` preset. Close animation
-- stays on a bezier because springs overshoot weirdly on shrink-out.
hl.curve("winSpring", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "windows",     enabled = true, speed = 5,    spring = "winSpring" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 4.1,  spring = "winSpring", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 1.49, bezier = "default",   style = "popin 87%" })
hl.animation({ leaf = "border",      enabled = true, speed = 5,    bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 4,    bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 3,    bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 3,    bezier = "default" })

-- Blur the Waybar layer (its CSS sets a translucent background).
hl.layer_rule({
    name         = "waybar-blur",
    match        = { namespace = "waybar" },
    blur         = true,
    ignore_alpha = 0.1,
})
