# Shell settings.

# Editor for `Ctrl-X Ctrl-E`-style buffer editing
$XONSH_AUTOPAIR = True

# "Did you mean?" suggestions on typo (replaces did_you_mean.nu)
$SUGGEST_COMMANDS = True
$SUGGEST_MAX_NUM = 5
$SUGGEST_THRESHOLD = 3

# Vi mode (matches nushell `edit_mode = "vi"`)
$VI_MODE = True

# History — xonsh's local history is supplementary to atuin.
# erasedups is deprecated; run `history erasedups` manually if needed.
$XONSH_HISTORY_BACKEND = 'sqlite'
$XONSH_HISTORY_SIZE = (10000, 'commands')
$HISTCONTROL = {'ignoredups'}

# Autosuggestions — fish/zsh-autosuggestions style ghost text from history.
# Already default in xonsh; pinned so behaviour survives upgrades.
# Accept with Right Arrow or End; reject by typing.
$XONSH_PROMPT_AUTO_SUGGEST = True
$AUTO_SUGGEST_IN_COMPLETIONS = True

# Completions
$CASE_SENSITIVE_COMPLETIONS = False
$FUZZY_PATH_COMPLETION = True
$COMPLETIONS_CONFIRM = True
$UPDATE_COMPLETIONS_ON_KEYPRESS = True
$COMPLETION_IN_THREAD = True     # don't block the UI while computing
$COMPLETIONS_MENU_ROWS = 8
$COMPLETIONS_DISPLAY = 'multi'   # multi-column menu like zsh
$COMPLETION_QUERY_LIMIT = 0      # 0 disables the "List truncated" notice

# Syntax highlighting style for the prompt
$XONSH_COLOR_STYLE = 'monokai'

# Don't show xonsh tracebacks for plain command errors
$XONSH_SHOW_TRACEBACK = False
