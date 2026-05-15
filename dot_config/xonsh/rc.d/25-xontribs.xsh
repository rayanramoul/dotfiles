# Load xontribs (xonsh plugins).
#
# Installed by run_onchange_install-xontribs.sh:
#   xontrib-fish-completer  → fish_completer  (rich completions with descriptions)
#   xontrib-jedi            → jedi            (Python REPL completion)
#   xontrib-cmd-durations   → cmd_done        (command duration in prompt)
#
# Note: pip package names use dashes; the importable module uses underscores
# and isn't always derivable from the package name (cmd-durations → cmd_done).
#
# Ctrl+R / Ctrl+T fzf bindings are wired directly in 40-keybindings.xsh
# rather than via xontrib-fzf-widgets, because that xontrib has a tmux-only
# bug (`which fzf_tmux_cmd` literal vs `which @(fzf_tmux_cmd)` deref) that
# crashes Ctrl+R inside tmux. Our handlers are short enough to inline.

from xonsh.xontribs import find_xontrib

for _xt in ('fish_completer', 'jedi', 'cmd_done'):
    if find_xontrib(_xt):
        execx(f'xontrib load {_xt}')
