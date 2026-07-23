-- Noctalia's generated Lua template reapplies these colors after this module.
local c = {
    primary        = "rgb(ebbcba)",
    surface        = "rgb(191724)",
    secondary      = "rgb(9ccfd8)",
    error          = "rgb(eb6f92)",
}

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
