<div align="center">
    <h1>Windows</h1>
</div>

# Summary :
- Fetch Script : Fastfetch
- Editor : Neovim (LazyVim)
- Terminal : Alacritty / Windows Terminal (Ghostty in WSL)
- Window Manager : GlazeWM
- Status Bar : GlazeWM bar (config in `dot_config/glaze_config.yaml`)
- Terminal Multiplexers : Tmux, Zellij (inside WSL)
- Hotkeys : Managed by GlazeWM
- Launcher : Wox
- Shells : Zsh + Powerlevel10k, Nushell + Starship + Carapace (inside WSL)
- Fonts : Meslo Nerd, JetBrains Mono, SF Mono, Nerd Fonts
- Color Scheme : Catppuccin Mocha
- AI Stack : Claude Code, Ollama, LM Studio, opencode (inside WSL)
- Other Terminal Utilities : bat, eza / lsd, fzf, ripgrep, fd, zoxide, atuin, just, tldr, lazygit, lazydocker, git-delta, bpytop

# How to
- Install [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) (Arch via [archwsl](https://github.com/yuk7/ArchWSL) is what this repo targets).
- Install [Wox](https://github.com/Wox-launcher/Wox/releases) launcher.
- Install [GlazeWM](https://github.com/glzr-io/glazewm). The config lives at `dot_config/glaze_config.yaml` in this repo and is symlinked by chezmoi to `%USERPROFILE%\.glzr\glazewm\config.yaml` (or copy it manually).
- Install a terminal — either [Alacritty](https://github.com/alacritty/alacritty/releases) or Windows Terminal (with [themes](https://terminalsplash.com/)).
- Install the Nerd Fonts (Meslo recommended) — see [`dot_fonts/`](../dot_fonts/).
- Make WSL Arch your default: `wsl --set-default Arch`.
- (Optional) Install [ExplorerPatcher](https://github.com/valinet/ExplorerPatcher/releases) to hide the Windows taskbar.

Inside WSL, run the chezmoi-based installer (same as Linux):

```bash
curl -fsSL https://raw.githubusercontent.com/rayanramoul/dotfiles/main/install.sh | bash
```

Or manually:

```bash
sudo pacman -S chezmoi
chezmoi init --apply https://github.com/rayanramoul/dotfiles
```
