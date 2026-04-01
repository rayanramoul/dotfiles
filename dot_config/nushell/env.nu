# env.nu
#
# Environment variables and PATH setup.
# Loaded before config.nu.

# Core
$env.LANG = "en_US.UTF-8"
$env.EDITOR = "nvim"
$env.DOCKER_BUILDKIT = "1"

# Bun
$env.BUN_INSTALL = $"($env.HOME)/.bun"

# Perl5
$env.PERL5LIB = $"($env.HOME)/perl5/lib/perl5"
$env.PERL_LOCAL_LIB_ROOT = $"($env.HOME)/perl5"
$env.PERL_MB_OPT = $"--install_base \"($env.HOME)/perl5\""
$env.PERL_MM_OPT = $"INSTALL_BASE=($env.HOME)/perl5"

# FZF theme (Catppuccin Mocha)
$env.FZF_DEFAULT_OPTS = (
  "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 " +
  "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc " +
  "--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
)

# PATH
$env.PATH = (
  $env.PATH
  | prepend [
      $"($env.HOME)/.local/bin"
      $"($env.HOME)/perl5/bin"
    ]
  | append [
      $"($env.HOME)/google-cloud-sdk/bin"
      $"($env.HOME)/miniconda3/bin"
      $"($env.BUN_INSTALL)/bin"
    ]
  | uniq
)

# Carapace completions
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
mkdir $"($nu.cache-dir)"
carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"

# Starship prompt
# Requires: starship init nushell | save -f ~/.config/nushell/starship.nu
source starship.nu
