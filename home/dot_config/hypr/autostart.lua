hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia &")
	hl.exec_cmd("vicinae server &")
	hl.exec_cmd("hypridle &")
	hl.exec_cmd("systemctl --user start plasma-polkit-agent")
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE"
	)
	-- Bring up the systemd graphical session so xdg-desktop-portal can start
	-- (needed for screen sharing of windows/screen and the Secret portal).
	hl.exec_cmd("systemctl --user start hyprland-session.target")
	hl.exec_cmd("udiskie --tray &")
end)
