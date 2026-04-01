# config.nu
#
# Shell settings, aliases, commands, and keybindings.

# ── Shell settings ─────────────────────────────────────────────────────────────

$env.config.show_banner = false
$env.config.buffer_editor = "nvim"
$env.config.edit_mode = "vi"

$env.config.history.sync_on_enter = true
$env.config.history.max_size = 10000
$env.config.history.isolation = false  # share history across sessions

$env.config.completions.algorithm = "fuzzy"
$env.config.completions.case_sensitive = false

$env.config.color_config = {
  command: "cyan"
  string: "green"
  error: "red"
}

# ── Aliases: editors ───────────────────────────────────────────────────────────

alias vim = nvim
alias vi = nvim
alias v = nvim
alias vimdiff = nvim -d

# ── Aliases: file browsing ─────────────────────────────────────────────────────

alias yz = yazi

# Note: `open` is a nushell built-in; use `xdg-open` directly or the def below
def xopen [...args: string] {
  ^xdg-open ...$args e>| ignore
}

# ── Aliases: system monitoring ─────────────────────────────────────────────────

alias top = bpytop
alias htop = bpytop
alias cat = bat

# ── Aliases: navigation (zoxide) ──────────────────────────────────────────────
# Requires: zoxide init nushell | save -f ~/.config/nushell/zoxide.nu
# Uncomment after generating:
# source ~/.config/nushell/zoxide.nu
# alias cd = z

# ── Aliases: git ───────────────────────────────────────────────────────────────

alias ga  = git add
alias gap = git add --patch
alias gb  = git branch
alias gba = git branch --all
alias gc  = git commit
alias gca = git commit --amend --no-edit
alias gce = git commit --amend
alias gco = git checkout
alias gcl = git clone --recursive
alias gd  = git diff --output-indicator-new=" " --output-indicator-old=" "
alias gds = git diff --staged --output-indicator-new=" " --output-indicator-old=" "
alias gi  = git init
alias gl  = git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n"
alias gm  = git merge
alias gn  = git checkout -b
alias gp  = git push
alias gr  = git reset
alias gs  = git status --short
alias gu  = git pull

# ── Aliases: docker ────────────────────────────────────────────────────────────

alias dps = docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
alias dl  = docker logs --tail=100
alias dc  = docker compose

# ── Aliases: tmux ──────────────────────────────────────────────────────────────

alias ta = tmux attach
alias tl = tmux list-sessions
alias tn = tmux new-session -s

# ── Aliases: chezmoi ───────────────────────────────────────────────────────────

alias cz  = chezmoi
alias cza = chezmoi apply
alias czd = chezmoi diff
alias czl = chezmoi ls
alias czp = chezmoi preview
alias czr = chezmoi resolve
alias czs = chezmoi status
alias czc = chezmoi cd

# ── Aliases: misc ──────────────────────────────────────────────────────────────

alias lg = lazygit
alias ld = lazydocker

# ── Custom commands ────────────────────────────────────────────────────────────

# Open (or attach to) a Notes tmux session with nvim
def notes [] {
  let has_session = (^tmux has-session -t Notes | complete | get exit_code) == 0
  let in_tmux = ($env | get -o TMUX | is-not-empty)

  if not $has_session {
    ^tmux new-session -ds Notes -c $"($env.HOME)/Documents/Notes" "nvim ."
  }

  if $in_tmux {
    ^tmux switch-client -t Notes
  } else {
    ^tmux attach-session -t Notes
  }
}

# Fuzzy-find and open a file or cd into a directory (Ctrl+e)
def fzf-open [] {
  let candidates = (
    do {
      ^find $"($env.HOME)/Downloads" $"($env.HOME)/Documents" -maxdepth 8 "(" -type f -o -type d ")"
    }
    | complete
    | get stdout
    | lines
    | str trim
    | where { |it| $it | is-not-empty }
  )
  let selected = (
    $candidates
    | to text
    | ^fzf --preview "bat --style=numbers --color=always --line-range=:500 {}" --preview-window "right:60%"
    | str trim
  )
  if ($selected | is-not-empty) {
    if ($selected | path type) == "dir" {
      cd $selected
    } else {
      nvim $selected
    }
  }
}

# ── Keybindings ────────────────────────────────────────────────────────────────

$env.config.keybindings = (
  $env.config.keybindings | append [
    # Ctrl+n → notes session
    {
      name: open_notes
      modifier: control
      keycode: char_n
      mode: [emacs vi_normal vi_insert]
      event: { send: executehostcommand cmd: "notes" }
    }
    # Ctrl+e → fzf file/dir picker
    {
      name: fzf_file_finder
      modifier: control
      keycode: char_e
      mode: [emacs vi_normal vi_insert]
      event: { send: executehostcommand cmd: "fzf-open" }
    }
    # Ctrl+f → tmux sessionizer
    {
      name: tmux_sessionizer
      modifier: control
      keycode: char_f
      mode: [emacs vi_normal vi_insert]
      event: { send: executehostcommand cmd: "tmux-sessionizer" }
    }
  ]
)

# ── Tool integrations ──────────────────────────────────────────────────────────

# Carapace completions
# Generate with: carapace _carapace nushell | save -f ($nu.cache-dir | path join "carapace.nu")
let carapace_path = ($nu.cache-dir | path join "carapace.nu")
if ($carapace_path | path exists) {
  source $"($nu.cache-dir)/carapace.nu"
}

