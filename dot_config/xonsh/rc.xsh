# xonsh main config.
#
# Modular config is auto-loaded from rc.d/ in lexicographic order:
#   00-env.xsh           PATH and environment variables
#   10-settings.xsh      shell settings, history, vi mode
#   20-aliases.xsh       command aliases
#   30-commands.xsh      custom Python-defined commands
#   40-keybindings.xsh   prompt_toolkit keybindings
#   50-integrations.xsh  starship, atuin, zoxide, carapace
#
# Keep this file empty unless something must run before rc.d/ is processed.
