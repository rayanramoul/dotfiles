# Custom keybindings (prompt_toolkit).
#
# Ctrl+r  → fzf history search
# Ctrl+t  → fzf file picker (inserts selected path at cursor)
# Ctrl+n  → notes tmux session
# Ctrl+e  → custom fzf file/dir picker (Downloads + Documents)
# Ctrl+f  → tmux sessionizer
# ↑ / ↓  → zsh-style history-prefix-search (type "git " then ↑ to filter)
#
# `eager=True` overrides prompt_toolkit's built-in bindings.

import subprocess

from prompt_toolkit.application import run_in_terminal
from prompt_toolkit.keys import Keys
from xonsh.history.main import history_main


@events.on_ptk_create
def _custom_keybindings(prompter, history, completer, bindings, **kw):

    @bindings.add(Keys.ControlR, eager=True)
    def _fzf_history(event):
        # Feed xonsh history (null-delimited) to fzf, replace buffer with choice.
        # Inlined instead of using xontrib-fzf-widgets because that xontrib's
        # tmux-detection code crashes inside tmux.
        fzf_cmd = [
            'fzf', '--read0', '--tac', '--tiebreak=index', '+m', '--reverse',
            '--height=40%', '--bind=ctrl-r:toggle-sort',
        ]
        if event.current_buffer.text:
            fzf_cmd += ['-q', '^' + event.current_buffer.text]

        proc = subprocess.Popen(
            fzf_cmd, stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True,
        )
        history_main(args=['show', '-0', 'all'], stdout=proc.stdin)
        proc.stdin.close()
        proc.wait()
        choice = proc.stdout.read().strip()
        event.app.renderer.erase()
        if choice:
            event.current_buffer.text = choice
            event.current_buffer.cursor_position = len(choice)

    @bindings.add(Keys.ControlT, eager=True)
    def _fzf_file(event):
        # Run fzf in cwd (honours $FZF_DEFAULT_COMMAND), insert quoted paths.
        result = subprocess.run(
            ['fzf', '-m', '--reverse', '--height=40%'],
            stdout=subprocess.PIPE, text=True,
        )
        event.app.renderer.erase()
        choice = result.stdout.strip()
        if choice:
            picked = ' '.join(f"'{f}'" for f in choice.splitlines() if f)
            event.current_buffer.insert_text(picked)

    @bindings.add(Keys.ControlN, eager=True)
    def _open_notes(event):
        run_in_terminal(lambda: _notes([]))

    @bindings.add(Keys.ControlE, eager=True)
    def _fzf_picker(event):
        run_in_terminal(lambda: _fzf_open([]))

    @bindings.add(Keys.ControlF, eager=True)
    def _tmux_sessionizer(event):
        run_in_terminal(lambda: subprocess.run(['tmux-sessionizer']))

    # zsh history-substring-search style: move within multi-line buffer if
    # not at edge, otherwise step through history filtered by current prefix.
    @bindings.add(Keys.Up, eager=True)
    def _hist_prefix_up(event):
        buf = event.current_buffer
        if buf.document.cursor_position_row > 0:
            buf.cursor_up(count=event.arg)
        else:
            buf.history_backward(count=event.arg, history_search=True)

    @bindings.add(Keys.Down, eager=True)
    def _hist_prefix_down(event):
        buf = event.current_buffer
        if buf.document.cursor_position_row < buf.document.line_count - 1:
            buf.cursor_down(count=event.arg)
        else:
            buf.history_forward(count=event.arg, history_search=True)
