<div align="center">
    <h1>Terminal</h1>
</div>

# Terminal Emulators
- **Linux / macOS** : [Ghostty](https://ghostty.org/) — config in `dot_config/ghostty/`.
- **Windows** : Alacritty or Windows Terminal (Ghostty inside WSL).

# Shells
Two shells are configured side-by-side:

- **Zsh** with [Powerlevel10k](https://github.com/romkatv/powerlevel10k) — primary login shell. Config: `dot_zshrc` + `dot_p10k.zsh`.
- **Nushell** with [Starship](https://starship.rs/) and [Carapace](https://carapace.sh/) for completions across CLIs. Config: `dot_config/nushell/`.

# Added Zsh Keybindings
- `Ctrl + e` : global fuzzy finder over `~/Downloads` and `~/Documents` with `bat` preview.
- `Ctrl + f` : tmux sessionizer.
- `Ctrl + n` : open a persistent `Notes` tmux session in `~/Documents/Notes`.

# Useful Aliases
- `vim`, `vi`, `v` → `nvim`
- `cat` → `bat`, `ls` → `lsd`, `cd` → `z` ([z.sh](https://github.com/rupa/z))
- `top`, `htop` → `bpytop`
- `lg` → `lazygit`, `ld` → `lazydocker`
- `cz*` → chezmoi shortcuts (`cza` apply, `czd` diff, `czs` status, …)
- `g*` → git shortcuts (`gs` status, `gp` push, `gu` pull, …)

# History — Atuin
[`atuin`](https://atuin.sh/) replaces the default shell history with a synced, searchable database. `Ctrl+R` is mapped to atuin's fuzzy history picker.

# Compare fonts for code
https://www.codingfont.com/

# Tools Used
- [Ghostty](https://ghostty.org/) — terminal emulator
- [LazyGit](https://github.com/jesseduffield/lazygit) — git TUI
- [LazyDocker](https://github.com/jesseduffield/lazydocker) — docker TUI
- [Yazi](https://github.com/sxyazi/yazi) — file manager
- [bat](https://github.com/sharkdp/bat) — `cat` with syntax highlighting
- [eza](https://github.com/eza-community/eza) / [lsd](https://github.com/lsd-rs/lsd) — modern `ls`
- [fzf](https://github.com/junegunn/fzf) — fuzzy finder
- [ripgrep](https://github.com/BurntSushi/ripgrep) / [fd](https://github.com/sharkdp/fd) — fast grep / find
- [zoxide](https://github.com/ajeetdsouza/zoxide) — smarter `cd`
- [atuin](https://github.com/atuinsh/atuin) — shell history
- [starship](https://starship.rs/) — prompt (used for Nushell)
- [just](https://github.com/casey/just) — command runner
- [git-delta](https://github.com/dandavison/delta) / [difftastic](https://github.com/Wilfred/difftastic) — diff viewers
- [bpytop](https://github.com/aristocratos/bpytop) — system monitor
- [tldr](https://github.com/tldr-pages/tldr) — short man pages
