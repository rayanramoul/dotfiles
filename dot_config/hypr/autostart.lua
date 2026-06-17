local home = os.getenv("HOME")

hl.on("hyprland.start", function()
    hl.exec_cmd("awww-daemon &")
    hl.exec_cmd(home .. "/.local/share/chezmoi/scripts/executable_wallpaperctl.sh start &")
    hl.exec_cmd("vicinae server &")
    hl.exec_cmd("qs -c noctalia-shell &")
    hl.exec_cmd("hypridle &")
    hl.exec_cmd("clipboard-sync &")
    hl.exec_cmd("systemctl --user start plasma-polkit-agent")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
    -- Bring up the systemd graphical session so xdg-desktop-portal can start
    -- (needed for screen sharing of windows/screen and the Secret portal).
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    hl.exec_cmd("copyq --start-server")
    hl.exec_cmd("gammastep -c " .. home .. "/.config/gammastep/config.ini")
    hl.exec_cmd("udiskie --tray &")
end)
