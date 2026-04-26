<div align="center">
    <h1>MacOS</h1>
</div>

# Table of Content
- [Tiling Window Management](#how-to-have-tiling-window-management-and-keybindings)
- [Setup Top Bar](#setup-a-top-bar)
- [My Dotfiles](#get-my-dotfiles)
- [Essential Apps](#essential-apps)
- [Other Interesting Apps](#other-interesting-apps)

# Summary :
- Fetch Script : Fastfetch
- Editor : Neovim (LazyVim)
- Terminal : Ghostty (Alacritty also supported)
- Window Manager : AeroSpace (replaces Yabai — no SIP changes required)
- Status Bar : SketchyBar (with JankyBorders for focus highlighting)
- Terminal Multiplexers : Tmux, Zellij
- Hotkeys : Managed by AeroSpace
- Launcher : Raycast
- File Manager : Yazi (TUI) / Finder (GUI)
- Shells : Zsh + Powerlevel10k, Nushell + Starship + Carapace
- Fonts : Meslo Nerd, JetBrains Mono, SF Mono, Nerd Fonts
- Color Scheme : Catppuccin Mocha
- AI Stack : Claude Code, Ollama, LM Studio, opencode
- Other Terminal Utilities : bat, eza, fzf, ripgrep, fd, zoxide, atuin, just, tldr, lazygit, lazydocker, git-delta, bpytop

# How To Have Tiling Window Management and Keybindings
- Install [AeroSpace](https://github.com/nikitabobko/AeroSpace) — i3-style tiling WM for macOS that does **not** require disabling SIP:
  ```bash
  brew install --cask nikitabobko/tap/aerospace
  ```
- Configuration lives in `~/.aerospace.toml` (provided by this repo as `dot_aerospace.toml`).
- AeroSpace handles all hotkeys natively, so `skhd` is no longer needed.
- (Historic note) Earlier versions of this repo used Yabai + skhd. They have been replaced by AeroSpace.

# Setup the Status Bar — SketchyBar
Configuration lives in `~/.config/sketchybar` and is wired to AeroSpace via the `exec-on-workspace-change` hook in `dot_aerospace.toml`.

```bash
brew tap FelixKratz/formulae
brew install sketchybar
```

# (Optional) Window borders — JankyBorders
Highlights the focused window, started automatically by AeroSpace's `after-startup-command`.

```bash
brew tap FelixKratz/formulae
brew install borders
```

In **System Settings > Desktop & Dock > Mission Control**:
- Uncheck *Automatically rearrange Spaces based on most recent use*.
- Check *Displays have separate Spaces*.

# Get my dotfiles
Dotfiles are managed with [chezmoi](https://chezmoi.io). The macOS-specific configs are AeroSpace (`~/.aerospace.toml`) and SketchyBar (`~/.config/sketchybar/`).

```bash
# One-liner — installs chezmoi if missing, then applies the repo
curl -fsSL https://raw.githubusercontent.com/rayanramoul/dotfiles/main/install.sh | bash
```

Or manually:

```bash
brew install chezmoi
chezmoi init --apply https://github.com/rayanramoul/dotfiles
```

After applying, restart AeroSpace and SketchyBar:

```bash
aerospace reload-config
brew services restart sketchybar
```

# Essential Apps
- Keeps Computer not sleepy : https://apps.apple.com/fr/app/amphetamine/id937984704?mt=12
- Mac native search is really limited, get a better spotlight : https://manual.raycast.com/
- (Optional) another spotlight alternative is [Alfred](https://www.alfredapp.com/), comparison between the 2 : https://joshcollinsworth.com/blog/alfred-raycast
- Better Screenshot tool : https://shottr.cc/
- Terminal of choice : [Ghostty](https://ghostty.org/) (Alacritty also works for cross-platform parity)


# Other Interesting Apps
- Resize windows like in Windows (install it if you didn't setup Tiling Window Management) : https://rectangleapp.com/
- Test of camera : https://apps.apple.com/us/app/hand-mirror/id1502839586?mt=12
- Bind hotkeys : https://apps.apple.com/fr/app/hotkey-app/id975890633?mt=12
- Optimize images sizes : https://imageoptim.com/mac
- Save apps for later to prepare calls/sharing screen : https://getlater.app/
- Download latest versions of apps : https://max.codes/latest/
- Read articles : https://quietreader.app/
- Local LLMs : [LM Studio](https://lmstudio.ai/) and [Ollama](https://ollama.com/)
- Coding agent in the terminal : [Claude Code](ClaudeCode.md) and [opencode](https://opencode.ai/)

# Keybinds
My keybindgs are the same accross all the OSs i use, you can find a recap of them [here](https://github.com/rayanramoul/RayTerm/blob/master/docs/Keybindings.md)
