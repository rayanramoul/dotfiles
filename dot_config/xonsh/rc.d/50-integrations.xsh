# Tool integrations: starship, atuin, zoxide, carapace.
#
# Each tool emits xonsh init code via `<tool> init xonsh`; we eval it with execx.
# Carapace replaces the per-command completion files that lived in nushell/completions/.

import shutil
import subprocess


def _exec_init(cmd):
    if not shutil.which(cmd[0]):
        return
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode == 0 and result.stdout.strip():
        execx(result.stdout)


# Starship prompt
_exec_init(['starship', 'init', 'xonsh'])

# Atuin (history) — records every command in the background, but Ctrl+R is
# owned by fzf-widgets (25-xontribs.xsh) for fzf-style history search. Use
# `atuin search` directly if you want atuin's UI.
_exec_init(['atuin', 'init', 'xonsh', '--disable-up-arrow', '--disable-ctrl-r'])

# Zoxide (smart cd)
_exec_init(['zoxide', 'init', 'xonsh'])

# Carapace (completions for git, docker, gh, cargo, kubectl, …)
_exec_init(['carapace', '_carapace', 'xonsh'])
