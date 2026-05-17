<div align="center">

<h1>RayTerm</h1>
<p><em>An opinionated, reproducible coding environment across Linux, macOS and Windows.</em></p>

![RayTerm](https://github.com/rayanramoul/dotfiles/blob/main/assets/rayterm_screenshot.png?raw=true)

</div>

## What is this?

A set of dotfiles + a package manifest that, in one command, gives you:

- Tiling window management on every OS — **Hyprland** (Linux), **AeroSpace** (macOS), **GlazeWM** (Windows).
- Coherent keybindings across all three (mapped to `SUPER` on Linux/Windows, `Alt` on macOS).
- Terminal-first stack — **xonsh** + **tmux** + **Neovim (LazyVim)** + **Ghostty**.
- Rose-Pine theming everywhere — GTK / Qt (Kvantum) / KDE / terminal.
- AI-native — Claude Code, Ollama, LM Studio, opencode wired in.
- Everything managed by [chezmoi](https://chezmoi.io) — declarative, reproducible, one-line bootstrap.

## Quick install

```bash
# One-liner (Linux + macOS)
curl -fsSL https://raw.githubusercontent.com/rayanramoul/dotfiles/main/install.sh | bash
```

Or manual:

```bash
# 1. Install chezmoi
sudo pacman -S chezmoi               # Arch / CachyOS
brew install chezmoi                 # macOS
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"  # Ubuntu / Debian

# 2. Apply
chezmoi init --apply https://github.com/rayanramoul/dotfiles
```

`chezmoi apply` chains `run_onchange_install-packages.sh` (paru / brew / apt) and `run_onchange_post-install-services.sh` (enables sshd, docker). Repeat any time.

## Stack at a glance

| Layer | Linux (Arch / CachyOS) | macOS | Windows |
| --- | --- | --- | --- |
| Window manager | Hyprland | AeroSpace | GlazeWM |
| Status bar | Noctalia | SketchyBar (+ JankyBorders) | GlazeWM bar |
| Launcher | Vicinae | Raycast | Wox |
| Terminal | Ghostty | Ghostty | Alacritty / Windows Terminal |
| Shell | xonsh + Starship + Atuin + Carapace | same | same (via WSL) |
| Editor | Neovim (LazyVim) | same | same |
| Multiplexer | Tmux (rose-pine theme) | same | same |
| File manager | Yazi (TUI) / Dolphin (GUI) | Yazi / Finder | Yazi / Explorer |
| Lock / idle | Hyprlock + Hypridle | — | — |
| Wallpaper | swww (via `wallpaperctl.sh`) | — | — |
| Notifications | SwayNC + Noctalia | native | native |
| Screenshots | grim + slurp + satty | Shottr | — |
| Theme | Rose-Pine (GTK / Kvantum / KDE / Terminal) | same | same |

CLI tools available everywhere: `bat`, `lsd`, `fzf`, `ripgrep`, `fd`, `zoxide`, `atuin`, `starship`, `just`, `git-delta`, `difftastic`, `lazygit`, `lazydocker`, `btop`, `tealdeer`, `glow`, `dive`, `topgrade`, `fastfetch`, `onefetch`, `presenterm`, `mise`.

## Keybindings

Open the live cheatsheet anytime with **`SUPER + /`** (renders via `glow` in a floating Ghostty).

### Apps & system

| Key | Action |
| --- | --- |
| `SUPER + Return` | Open terminal (Ghostty) |
| `SUPER + Q` | Kill focused window |
| `SUPER + Space` | Launcher (Vicinae) |
| `SUPER + Ctrl + E` | Emoji picker |
| `SUPER + E` | File manager (Dolphin) |
| `SUPER + V` | Toggle floating |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + P` | Pin / unpin active window |
| `SUPER + /` | Open this cheatsheet |
| `SUPER + X` | Lock (`hyprlock`) |
| `SUPER + End` | Region screenshot → satty → clipboard |
| `SUPER + W` / `Shift + W` | Next / previous wallpaper |
| `SUPER + C` | Zen browser at chat.com (workspace 2) |
| `SUPER + Shift + D` | Ghostty + nvim in chezmoi source |
| `SUPER + Shift + A` | `chezmoi apply` + reload Hyprland |
| `SUPER + Shift + C` | Notes tmux session |
| `SUPER + Shift + M` | Supersonic (music) |
| `SUPER + Shift + O` | Obsidian (vault) |
| `SUPER + Shift + V` | Toggle copyq clipboard history |

### Focus & movement

| Key | Action |
| --- | --- |
| `SUPER + H/J/K/L` or arrows | Focus left / down / up / right |
| `SUPER + Shift + H/J/K/L` | Move window |
| `SUPER + Ctrl + H/J/K/L` | Resize (20px or column preset) |
| `SUPER + Comma` / `Period` | Focus monitor left / right |
| `SUPER + Tab` | Toggle previous workspace |
| `SUPER + 1-0` | Switch workspace 1-10 |
| `SUPER + Shift + 1-0` | Move window to workspace |
| `SUPER + S` / `Shift + S` | Toggle / move-to scratchpad |
| `SUPER + Wheel` | Cycle workspaces |
| `SUPER + LMB` / `RMB` | Drag / resize with mouse |

### Workspaces (auto-routed by class)

| WS | Name | Monitor | Routes |
| --- | --- | --- | --- |
| 1 | 󰆍 terminal | DP-1 | Ghostty, Alacritty, Kitty |
| 2 | 󰖟 browser | DP-2 | Zen, Helium, Firefox, Chrome |
| 3 | 󰨞 code | DP-1 | VSCode, Cursor |
| 4 | 󰭹 chat | DP-2 | Discord, Slack, Signal, Spotify |
| 5 | 󰊗 games | DP-1 | Steam, Lutris, Heroic, wine |
| 6 | 󰒍 vault | DP-2 | Bitwarden, Obsidian, GIMP, Inkscape |
| 7 | 󰋋 media | DP-2 | Supersonic, Stremio |
| 8-10 | 󰀻 misc | — | transmission-qt, scratch |

### Media

| Key | Action |
| --- | --- |
| `XF86AudioPlay` / `Prev` / `Next` | `playerctl` |
| `XF86AudioRaise/LowerVolume` | `pactl` ±5% |
| `XF86AudioMicMute` | mic mute toggle |
| `XF86MonBrightnessUp/Down` | `brightnessctl` ±5% |

## Apps & system map

- **Browser** — Zen Browser (Helium also installed)
- **File explorer** — Yazi (TUI), Dolphin (GUI)
- **Clipboard** — `wl-clipboard`, `copyq` (history)
- **Audio** — PipeWire stack (`pipewire-pulse`, `wireplumber`, `pavucontrol`)
- **Bluetooth** — `overskride`
- **Networking** — `nm-connection-editor` (tray via Noctalia)
- **Notifications** — `swaync`
- **Color picker** — `hyprpicker` (planned)
- **Music** — Supersonic (Navidrome client, rose-pine themed)
- **Video / streaming** — mpv (with yt-dlp), Stremio
- **Notes** — Obsidian (vault) + `~/Documents/Notes` (nvim via `SUPER + Shift + C`)
- **Messaging** — Signal, Discord
- **Local LLMs** — `ollama-cuda`, `lmstudio-bin`
- **Coding agents** — [Claude Code](#claude-code-setup), `opencode`
- **Gaming** — Steam + ProtonPlus, Lutris, Heroic, SteamTinkerLaunch
- **Documents** — `zathura` (PDF), `glow` (markdown)
- **Backups** — _TODO: restic_

## Per-OS notes

### Arch / CachyOS

- All packages declared in `.chezmoidata/packages.yaml` and installed via `paru` by `run_onchange_install-packages.sh.tmpl`.
- Autostart entries (vicinae, noctalia, hypridle, copyq, gammastep, udiskie, …) live in `dot_config/hypr/autostart.lua`.
- Quick OS bootstrap: boot the Arch ISO → `archinstall` → log in → run the install one-liner above. NVIDIA drivers, kernel mode-setting, multilib: see the [Arch wiki — NVIDIA](https://wiki.archlinux.org/title/NVIDIA).

### macOS

- AeroSpace replaces Yabai/skhd (no SIP changes required): `brew install --cask nikitabobko/tap/aerospace`.
- SketchyBar + JankyBorders for the bar / focus ring: `brew install sketchybar borders`.
- After applying: `aerospace reload-config && brew services restart sketchybar`.
- Best-spotlight: [Raycast](https://manual.raycast.com/).

### Windows

- Run inside [WSL Arch](https://github.com/yuk7/ArchWSL) for shell parity.
- Native side: [GlazeWM](https://github.com/glzr-io/glazewm) (config at `dot_config/glaze_config.yaml`), [Wox](https://github.com/Wox-launcher/Wox/releases) launcher, optional [ExplorerPatcher](https://github.com/valinet/ExplorerPatcher) to hide the taskbar.
- `wsl --set-default Arch`, then run the one-liner from inside WSL.

## AI tooling

- **[Claude Code](https://claude.com/claude-code)** is the main coding agent. Install: `npm install -g @anthropic-ai/claude-code`. Optional [`claude-diff`](https://github.com/gandarfh/claude-diff) hook for visual diffs of proposed edits.
- **[opencode](https://opencode.ai/)** — alternative CLI agent, points at the local Ollama by default (`mod+Shift+O` style envs are wired in xonsh).
- **Ollama (CUDA)** + **LM Studio** for local model hosting.
- Neovim integrations: `claude-code.nvim`, `minuet-ai`, `codediff` / `vscode-diff` for AI-edit previews. Config in `dot_config/nvim/lua/plugins/`.

## Repo layout

```
.chezmoidata/packages.yaml         # all packages, per-OS
.chezmoi.toml.tmpl                 # bootstrap config (prompts for git identity)
.chezmoiignore                     # secrets / state files to never track
dot_config/                        # → ~/.config/
private_dot_ssh/, private_*        # mode-0600 dirs (still in git — see chezmoiignore)
run_onchange_install-packages.sh.tmpl
run_onchange_install-xontribs.sh.tmpl
run_onchange_install-kvantum-rose-pine.sh
run_onchange_post-install-services.sh.tmpl   # enable sshd, docker.socket
run_onchange_remove-legacy.sh                # purge old zsh/p10k/etc.
justfile                           # `just apply / diff / bootstrap / upgrade`
docs/cheatsheets/                  # git, ssh, vscode reference cards
```

`just` recipes wrap the common chezmoi flows: `just apply`, `just diff`, `just bootstrap <repo>`, `just upgrade` (topgrade), `just unmanaged` (find files chezmoi doesn't track).

## Cheatsheets

Outside-the-stack reference material lives in [`docs/cheatsheets/`](docs/cheatsheets/) — short notes on git, ssh, and a vscode PDF. Use `glow docs/cheatsheets/git.md` for in-terminal rendering.

## ❤️ If RayTerm has been helpful

Star the repo — it helps others discover it.
