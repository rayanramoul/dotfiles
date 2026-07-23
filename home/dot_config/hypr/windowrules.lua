-- Apply `props` to each class in `list` as its own window_rule.
local function each_class(list, props)
	for _, cls in ipairs(list) do
		local spec = { match = { class = cls } }
		for k, v in pairs(props) do
			spec[k] = v
		end
		hl.window_rule(spec)
	end
end

-- Route by class
each_class({
	"^helium$",
	"^(Navigator|Firefox|firefox|firefoxdeveloperedition|firefox-esr|firefox-nightly)$",
	"^(Brave-browser|Brave-browser-nightly)$",
	"^(Chromium|Chromium-browser|Google-chrome|Google-chrome-stable|Google-chrome-beta|Google-chrome-unstable)$",
	"^Vivaldi-stable$",
	"^(zen-bin|zen|Zen|Zen-browser)$",
}, { workspace = "2" })

each_class({
	"^(Alacritty|Tilix|Kitty|kitty|ghostty|Ghostty|com\\.mitchellh\\.ghostty)$",
}, { workspace = "1" })
hl.window_rule({ match = { title = "RayTerm" }, workspace = "1" })

each_class({ "^(Code|code)$", "^(Cursor|cursor)$" }, { workspace = "3" })

hl.window_rule({
	match = { class = "^(discord|Discord|Spotify|Slack|slack|Signal|signal-desktop)$" },
	workspace = "4",
})

-- Vault: secrets + creative
hl.window_rule({ match = { class = "^Bitwarden$" }, workspace = "6" })
each_class({ "^(obsidian|Obsidian)$" }, { workspace = "6" })
each_class({ "^(Gimp|gimp|Inkscape)$" }, { workspace = "6" })

-- Media: music + streaming
each_class({
	"^(Supersonic|supersonic|supersonic-desktop)$",
	"^(Stremio|stremio|com\\.stremio\\.Stremio)$",
}, { workspace = "7" })

-- Downloads
hl.window_rule({
	match = { class = "^(transmission-qt|Transmission-qt|Transmission)$" },
	workspace = "8",
})

-- Floating utility dialogs (audio/network/theme/system)
each_class({
	"^[Pp]avucontrol$",
	"^nm-connection-editor$",
	"^(overskride|com\\.github\\.bjarosze\\.overskride)$",
	"^lxappearance$",
	"^[Nn]wg-look$",
	"^xsensors$",
	"^(qalculate-gtk|org\\.gnome\\.Calculator|gnome-calculator)$",
}, { float = true })

-- Zen browser — full opacity, no blur.
hl.window_rule({
	match = { class = "^(zen-bin|zen|Zen|Zen-browser)$" },
	opacity = 1.0, -- Full opacity
	no_blur = true, -- Disable blur
})

-- Satty screenshot annotation — floating centered window.
hl.window_rule({ match = { class = "^com\\.gabm\\.satty$" }, float = true })
hl.window_rule({ match = { class = "^com\\.gabm\\.satty$" }, center = true })
hl.window_rule({ match = { class = "^com\\.gabm\\.satty$" }, size = "1400 900" })
hl.window_rule({ match = { class = "^com\\.gabm\\.satty$" }, no_blur = true })
hl.window_rule({ match = { class = "^com\\.gabm\\.satty$" }, border_size = 0 })

-- Cheatsheet (mod+/) — floating glow terminal centered on current monitor.
-- Class is reverse-DNS because GTK rejects bare names as invalid app-id.
local CHEATSHEET = "^dev\\.local\\.cheatsheet$"
hl.window_rule({ match = { class = CHEATSHEET }, float = true })
hl.window_rule({ match = { class = CHEATSHEET }, size = "1100 800" })
hl.window_rule({ match = { class = CHEATSHEET }, center = true })
hl.window_rule({ match = { class = CHEATSHEET }, no_blur = true })
hl.window_rule({ match = { class = CHEATSHEET }, border_size = 0 })

-- Gaming launchers / clients / wrappers
local gaming = {
	-- Steam (both cases — actual class is lowercase `steam` for the main client)
	"^steam$",
	"^Steam$",
	"^Steam-native$",
	"^Steam-runtime$",
	"^Steam-native-runtime$",
	"^Steam Guard - Computer Authorization Required$",
	"^Steam - News$",
	"^Steam - Friends$",
	"^Steam - Library$",
	"^steam_app_.*$",
	"^com\\.valvesoftware\\.Steam$",

	-- Lutris
	"^lutris$",
	"^Lutris$",
	"^net\\.lutris\\.Lutris$",
	"^lutris_game_class$",

	-- Other launchers
	"^minecraft-launcher$",
	"^minigalaxy$",
	"^playnite_game_class$",
	"^heroic$",
	"^com\\.heroicgameslauncher\\.hgl$",
	"^r2modman$",
	"^itch$",
	"^io\\.itch\\.itch$",

	-- Streaming / remote play
	"^gamescope$",
	"^chiaki$",
	"^moonlight$",
	"^com\\.moonlight_stream\\.Moonlight$",

	-- Anything Wine
	"^.*[Ww]ine.*$",
}
each_class(gaming, { workspace = "5" })

-- Steam: tile the main "Steam" window. Popups/menus float on their own
-- requests, so no inverse rule needed (and RE2 has no negative lookahead).
hl.window_rule({
	match = { class = "^(steam|Steam|com\\.valvesoftware\\.Steam)$", title = "^Steam$" },
	tile = true,
})

-- Steam-launched games: float fullscreen, no border
hl.window_rule({
	match = { class = "^steam_app.*$" },
	float = true,
	fullscreen = true,
	border_size = 0,
})

-- Borderless / shadowless portal chrome
each_class({ "Xdg-desktop-portal-gtk" }, { border_size = 0 })
each_class({ "Xdg-desktop-portal-gtk" }, { no_shadow = true })

-- XWayland helper crud: prevent empty stray windows from stealing focus
hl.window_rule({
	match = { class = "^$", title = "^$", xwayland = true },
	float = true,
	no_focus = true,
})
hl.window_rule({ match = { xwayland = true }, no_blur = true })
hl.window_rule({ match = { title = "^\\(\\)$", class = "^steam$" }, stay_focused = true })
hl.window_rule({ match = { title = "^\\(\\)$", class = "^steam$" }, min_size = { 1, 1 } })

-- xwaylandvideobridge / Brave hidden helper: hide and ignore
each_class({ "^xwaylandvideobridge$", "^Brave-browser$" }, { no_anim = true })
each_class({ "^xwaylandvideobridge$", "^Brave-browser$" }, { no_initial_focus = true })
each_class({ "^xwaylandvideobridge$", "^Brave-browser$" }, { max_size = { 1, 1 } })

-- Picture-in-Picture overlays (Firefox, Brave naming variant)
hl.window_rule({ match = { title = "^Picture-in-Picture$" }, float = true })
hl.window_rule({ match = { title = "^Picture-in-Picture$" }, pin = true })
hl.window_rule({ match = { title = "^Brave$" }, float = true })
hl.window_rule({ match = { title = "^Brave$" }, pin = true })

-- Wine + RA: render immediately for low input latency
hl.window_rule({ match = { class = "^.*[Ww]ine.*$" }, immediate = true })
hl.window_rule({ match = { title = "^Red Alert" }, immediate = true })

-- Skyrim / Wine: keep rendering off-workspace (ENB/DXVK freezes on switch otherwise)
hl.window_rule({ match = { title = "^Skyrim Special Edition$" }, render_unfocused = true })
hl.window_rule({ match = { class = "^(skyrimse\\.exe|SkyrimSE\\.exe|skyrimse)$" }, render_unfocused = true })
hl.window_rule({ match = { class = "^steam_app_489830$" }, render_unfocused = true })

------------------------------------------------------------
-- Tag-based rules: tag windows first, then bundle effects.
------------------------------------------------------------

hl.window_rule({ match = { title = "Path of Exile" }, tag = "+poe" })
hl.window_rule({ match = { class = "steam_app_238960" }, tag = "+poe" })
hl.window_rule({ match = { title = "Awakened PoE Trade" }, tag = "+apt" })

hl.window_rule({ match = { tag = "poe" }, float = true })
hl.window_rule({ match = { tag = "poe" }, fullscreen = true })

-- Apply the same overlay bundle to anything tagged. Used for APT, easy to
-- reuse for other overlays. `fullscreen` covers the old `size = "100% 100%"`
-- + `center` combo, and avoids the Lua bridge's strict size parsing.
local function overlay_bundle(match, name_prefix)
	local rules = {
		{ float = true },
		{ no_focus = true },
		{ no_shadow = true },
		{ no_blur = true },
		{ border_size = 0 },
		{ pin = true },
		{ render_unfocused = true },
		{ fullscreen = true },
	}
	for i, props in ipairs(rules) do
		local spec = { match = match, name = name_prefix .. "-" .. i }
		for k, v in pairs(props) do
			spec[k] = v
		end
		hl.window_rule(spec)
	end
end

overlay_bundle({ tag = "apt" }, "apt-tag")

-- APT's class also gets the no-decoration treatment (catches windows that
-- haven't been tagged yet at first map).
hl.window_rule({
	name = "apt-base",
	match = { class = "awakened-poe-trade" },
	float = true,
	no_blur = true,
	no_shadow = true,
	border_size = 0,
})
