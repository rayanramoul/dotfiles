local home        = os.getenv("HOME")
local mainMod     = "SUPER"
local terminal    = "ghostty"
local fileManager = "dolphin"
local menu        = "vicinae toggle"

-- Apps
hl.bind(mainMod .. " + Return",     hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",          hl.dsp.window.close())
hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V",          hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Space",      hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + CTRL + E",   hl.dsp.exec_cmd("vicinae vicinae://extensions/vicinae/vicinae/search-emojis"))
hl.bind(mainMod .. " + J",          hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F",          hl.dsp.window.fullscreen())

-- Focus
local focus_keys = {
    H     = "left",  L     = "right", K  = "up",
    left  = "left",  right = "right", up = "up", down = "down",
}
for k, dir in pairs(focus_keys) do
    hl.bind(mainMod .. " + " .. k, hl.dsp.focus({ direction = dir }))
end

-- Move window
local move_keys = {
    H     = "left",  L     = "right", K  = "up",   J    = "down",
    left  = "left",  right = "right", up = "up",   down = "down",
}
for k, dir in pairs(move_keys) do
    hl.bind(mainMod .. " + SHIFT + " .. k, hl.dsp.window.move({ direction = dir }))
end

-- Workspaces 1..10 (silent move puts window without follow)
for i = 1, 10 do
    local key = i % 10  -- 10 maps to "0"
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, silent = true }))
end

-- Scratchpad
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Resize: layout-aware. Scrolling cycles through preset column widths from
-- `scrolling:explicit_column_widths` ("0.333, 0.5, 0.667, 1.0" by default),
-- which feels more useful than ±0.05 nudges because the layout has no fixed
-- total -- shrinking the active column doesn't grow its neighbor.
-- Everything else takes pixel deltas via window.resize.
local PIXEL_STEP = 20

local function smart_resize(dir)
    return function()
        local ws = hl.get_active_workspace()
        if ws and ws.tiled_layout == "scrolling" then
            if dir == "right" then hl.dispatch(hl.dsp.layout("colresize +conf")) end
            if dir == "left"  then hl.dispatch(hl.dsp.layout("colresize -conf")) end
            -- Vertical resize isn't meaningful in a column-based scrolling
            -- layout; up/down are no-ops here.
        else
            local dx, dy = 0, 0
            if dir == "right" then dx =  PIXEL_STEP end
            if dir == "left"  then dx = -PIXEL_STEP end
            if dir == "up"    then dy = -PIXEL_STEP end
            if dir == "down"  then dy =  PIXEL_STEP end
            hl.dispatch(hl.dsp.window.resize({ x = dx, y = dy, relative = true }))
        end
    end
end

local resize_keys = {
    { keys = { "right", "L" }, dir = "right" },
    { keys = { "left",  "H" }, dir = "left"  },
    { keys = { "up",    "K" }, dir = "up"    },
    { keys = { "down",  "J" }, dir = "down"  },
}
for _, r in ipairs(resize_keys) do
    for _, k in ipairs(r.keys) do
        hl.bind(mainMod .. " + CTRL + " .. k, smart_resize(r.dir))
    end
end

-- Mouse
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- Utilities
-- Region screenshot → satty annotation UI → clipboard.
-- grim+slurp give a true cross-monitor selection on Wayland (which
-- flameshot's portal-based grab can't do); satty replaces flameshot's UI.
hl.bind(mainMod .. " + End",        hl.dsp.exec_cmd([[grim -g "$(slurp)" - | satty --filename - --copy-command wl-copy --early-exit]]))
hl.bind(mainMod .. " + X",          hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + C",          hl.dsp.exec_cmd("zen-browser https://www.chat.com/ && hyprctl dispatch workspace 2"))

-- Dotfiles workflow
hl.bind(mainMod .. " + SHIFT + D",  hl.dsp.exec_cmd("ghostty -e nvim " .. home .. "/.local/share/chezmoi"))
hl.bind(mainMod .. " + SHIFT + A",  hl.dsp.exec_cmd("chezmoi apply --force --less-interactive --keep-going && hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + C",  hl.dsp.exec_cmd("ghostty -e nvim " .. home .. "/Documents/Notes"))

-- Wallpapers
hl.bind(mainMod .. " + W",          hl.dsp.exec_cmd(home .. "/.local/share/chezmoi/scripts/executable_wallpaperctl.sh next"))
hl.bind(mainMod .. " + SHIFT + W",  hl.dsp.exec_cmd(home .. "/.local/share/chezmoi/scripts/executable_wallpaperctl.sh prev"))

-- App launchers
hl.bind(mainMod .. " + SHIFT + M",  hl.dsp.exec_cmd("supersonic"))
hl.bind(mainMod .. " + SHIFT + O",  hl.dsp.exec_cmd("obsidian"))
hl.bind(mainMod .. " + SHIFT + V",  hl.dsp.exec_cmd("copyq toggle"))

-- Cheatsheet: glow-rendered docs/Keybindings.md in a floating terminal.
-- GTK app-id must be reverse-DNS (otherwise ghostty logs "invalid 'class'"
-- and falls back to com.mitchellh.ghostty, which would route to ws1 instead
-- of floating).
hl.bind(mainMod .. " + slash",      hl.dsp.exec_cmd("ghostty --class=dev.local.cheatsheet -e glow -p " .. home .. "/.local/share/chezmoi/docs/Keybindings.md"))

-- Window ops
hl.bind(mainMod .. " + P",          hl.dsp.window.pin())

-- Workspace / monitor nav
hl.bind(mainMod .. " + Tab",        hl.dsp.focus({ workspace = "previous" }))
hl.bind(mainMod .. " + Comma",      hl.dsp.focus({ monitor = "l" }))
hl.bind(mainMod .. " + Period",     hl.dsp.focus({ monitor = "r" }))

-- Brightness
hl.bind("XF86MonBrightnessUp",      hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",    hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

-- Awakened PoE Trade: pass keys to the overlay
hl.bind("SHIFT + Space",  hl.dsp.pass({ window = "class:awakened-poe-trade" }))
hl.bind("CTRL + ALT + D", hl.dsp.pass({ window = "class:awakened-poe-trade" }))

-- Media
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd("playerctl previous"),                          { locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd("playerctl play-pause"),                        { locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd("playerctl next"),                              { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"),     { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"),     { locked = true, repeating = true })
