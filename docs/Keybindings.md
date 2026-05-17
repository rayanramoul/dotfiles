
# Keybindings Reference

Cross-OS keybindings shared by Hyprland (Linux), AeroSpace (macOS) and GlazeWM (Windows). `$mod` is `SUPER` on Linux/Windows and `Alt` on macOS (AeroSpace's i3 default).

## Apps & system

| Keybinding | Action |
| --- | --- |
| `$mod + Return` | Open terminal (Ghostty / Alacritty) |
| `$mod + Q` | Kill focused window |
| `$mod + Space` | Open launcher (Vicinae / Raycast / Wox) |
| `$mod + E` | Open file manager (Dolphin / Finder / Explorer) |
| `$mod + V` | Toggle floating |
| `$mod + F` | Toggle fullscreen |
| `$mod + W` / `$mod + Shift + W` | Next / previous wallpaper (Linux only) |
| `$mod + End` | Region screenshot → annotate (`grim + slurp + satty`) → clipboard |
| `$mod + X` | Lock screen (`hyprlock`) |
| `$mod + C` | Open Zen browser at chat.com on workspace 2 |
| `$mod + Shift + D` | Open Ghostty + Neovim in the chezmoi source dir |
| `$mod + Shift + A` | `chezmoi apply` and reload Hyprland |
| `$mod + Shift + C` | Open the Obsidian-style Notes tmux session |

## Focus & movement

| Keybinding | Action |
| --- | --- |
| `$mod + H/J/K/L` (or arrows) | Focus left / down / up / right |
| `$mod + Shift + H/J/K/L` | Move window in the same direction |
| `$mod + Ctrl + H/J/K/L` | Resize active window by 20px |
| `$mod + 1-9, 0` | Switch to workspaces 1-10 |
| `$mod + Shift + 1-9, 0` | Move window to workspace 1-10 |
| `$mod + S` / `$mod + Shift + S` | Toggle / move-to scratchpad workspace |
| `$mod + mouse_wheel` | Cycle workspaces |
| `$mod + LMB` / `$mod + RMB` | Drag / resize window with mouse |

## Media

| Keybinding | Action |
| --- | --- |
| `XF86AudioPlay` / `Prev` / `Next` | `playerctl` play-pause / previous / next |
| `XF86AudioRaise/LowerVolume` | `pactl` volume ±5% |
| `XF86AudioMicMute` | Toggle microphone mute |
