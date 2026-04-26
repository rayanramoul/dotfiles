<div align="center">

<h1>RayTerm</h1>
<h6 align="center">
  <a href="https://github.com/rayanramoul/dotfiles/blob/main/docs/Neovim.md">Neovim</a>
  ·
  <a href="https://github.com/rayanramoul/dotfiles/blob/main/docs/Terminal.md">Terminal</a>
  ·
  <a href="https://github.com/rayanramoul/dotfiles/blob/main/docs/Tmux.md">Tmux</a>
  ·
  <a href="https://github.com/rayanramoul/dotfiles/blob/main/docs/ArchLinux.md">ArchLinux</a>
  ·
  <a href="https://github.com/rayanramoul/dotfiles/blob/main/docs/MacOS.md">MacOS</a>
  ·
  <a href="https://github.com/rayanramoul/dotfiles/blob/main/docs/Windows.md">Windows</a>
</h6>

![RayTerm](https://github.com/rayanramoul/dotfiles/blob/main/assets/screenshot.png?raw=true)

</div>

# Get Started with one command

**Automated installation (Linux and MacOS):**

```bash
curl -fsSL https://raw.githubusercontent.com/rayanramoul/dotfiles/main/install.sh | bash
```

**Manual installation:**

```bash
# Install chezmoi (https://chezmoi.io)
# Arch Linux
sudo pacman -S chezmoi

# Ubuntu/Debian (no apt package — use the upstream installer)
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"

# MacOS
brew install chezmoi

# Then apply dotfiles
chezmoi init --apply https://github.com/rayanramoul/dotfiles
# or if you have SSH access
chezmoi init --apply git@github.com:rayanramoul/dotfiles
```

After applying, run the package installer to pick up everything from `.chezmoidata/packages.yaml`:

```bash
chezmoi cd && ./run_onchange_install-packages.sh.tmpl
```


# What is this ?

RayTerm is a set of configurations, dotfiles and software defining an opinionated, optimal environment to code in.
It is :

- Tiling Window Management on every OS (Hyprland on Linux, AeroSpace on macOS, GlazeWM on Windows).
- Coherent and reproducible workflows from an OS to another, managed with [chezmoi](https://chezmoi.io).
- Strongly relying on terminal tools : Neovim, Tmux/Zellij, Zsh, Nushell, Fzf, etc.
- AI-native — first-class integration with Claude Code, Ollama, LM Studio and opencode.
- All prettier with Catppuccin Mocha (and pywal for dynamic theming).

# How ?

The idea is to have one main key associated with each part of the system

- `SUPER` for the window manager.
- `Ctrl` for the terminal.
- `Ctrl + b` for tmux.
- `Ctrl` and `Space` for neovim.

# Stack at a glance

| Layer | Linux (Arch / CachyOS) | macOS | Windows |
| --- | --- | --- | --- |
| Window manager | Hyprland | AeroSpace | GlazeWM |
| Status bar | Waybar / HyprPanel / Noctalia | SketchyBar (+ JankyBorders) | GlazeWM bar |
| Launcher | Vicinae (Raycast-style) | Raycast | Wox |
| Terminal | Ghostty | Ghostty / Alacritty | Alacritty / Windows Terminal |
| Shells | Zsh (Powerlevel10k) + Nushell (Starship) | same | same (via WSL) |
| Editor | Neovim (LazyVim) | Neovim (LazyVim) | Neovim (LazyVim) |
| Multiplexer | Tmux / Zellij | Tmux / Zellij | Tmux / Zellij |
| File manager | Yazi / Dolphin | Yazi / Finder | Yazi / Explorer |
| Lock / idle | Hyprlock + Hypridle | — | — |
| Wallpaper | swww (with `wallpaperctl.sh`) | — | — |
| Notifications | SwayNC | native | native |

Shared CLI utilities across all platforms: `bat`, `eza` / `lsd`, `fzf`, `ripgrep`, `fd`, `zoxide`, `atuin`, `starship`, `just`, `git-delta`, `difftastic`, `lazygit`, `lazydocker`, `bpytop`, `tldr`, `yazi`.

AI tooling: [Claude Code](docs/ClaudeCode.md) (with `claude-diff` hook), Ollama, LM Studio, opencode, and Neovim integrations (`claude-code.nvim`, `minuet`, custom code-diff/preview plugins).

# Docs

You can find my documentation of each part of my workflow in the [docs](docs) folder.

- [Neovim](docs/Neovim.md): My neovim configuration.
- [Terminal](docs/Terminal.md): My terminal configuration.
- [Tmux](docs/Tmux.md): My tmux configuration.
- [ArchLinux](docs/ArchLinux.md): My ArchLinux workflow guide.
- [MacOS](docs/MacOS.md): My MacOS workflow guide.
- [Windows](docs/Windows.md): My Windows workflow guide.

# ❤️ Enjoying RayTerm?

If RayTerm has been helpful to you, please consider giving it a star! ⭐ It helps others discover the repository and shows appreciation for the effort put into creating and maintaining it.

Thank you for your support! 🚀
