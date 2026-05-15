# Environment variables and PATH.

HOME = $HOME

# Core
$LANG = 'en_US.UTF-8'
$EDITOR = 'nvim'
$DOCKER_BUILDKIT = '1'

# Bun
$BUN_INSTALL = f'{HOME}/.bun'

# Perl5
$PERL5LIB = f'{HOME}/perl5/lib/perl5'
$PERL_LOCAL_LIB_ROOT = f'{HOME}/perl5'
$PERL_MB_OPT = f'--install_base "{HOME}/perl5"'
$PERL_MM_OPT = f'INSTALL_BASE={HOME}/perl5'

# FZF theme (Catppuccin Mocha)
$FZF_DEFAULT_OPTS = (
    '--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 '
    '--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc '
    '--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8'
)

# PATH — $PATH is a list in xonsh
_prepend = [
    '/opt/homebrew/bin',
    '/opt/homebrew/sbin',
    f'{HOME}/.local/bin',
    f'{HOME}/perl5/bin',
]
_append = [
    f'{HOME}/google-cloud-sdk/bin',
    f'{HOME}/miniconda3/bin',
    f'{$BUN_INSTALL}/bin',
    f'{HOME}/.lmstudio/bin',
]
for _p in reversed(_prepend):
    if _p not in $PATH:
        $PATH.insert(0, _p)
for _p in _append:
    if _p not in $PATH:
        $PATH.append(_p)
del _prepend, _append, _p
