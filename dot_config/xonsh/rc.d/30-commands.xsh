# Custom commands ported from config.nu.

import os
import subprocess


def _xopen(args):
    # xdg-open with stdout/stderr suppressed (matches nu `xopen` def)
    subprocess.Popen(
        ['xdg-open', *args],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def _notes(args):
    # Open (or attach to) a Notes tmux session with nvim
    home = $HOME
    has_session = subprocess.run(
        ['tmux', 'has-session', '-t', 'Notes'],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    ).returncode == 0
    in_tmux = bool(os.environ.get('TMUX'))

    if not has_session:
        subprocess.run([
            'tmux', 'new-session', '-ds', 'Notes',
            '-c', f'{home}/Documents/Notes',
            'nvim .',
        ])

    if in_tmux:
        subprocess.run(['tmux', 'switch-client', '-t', 'Notes'])
    else:
        subprocess.run(['tmux', 'attach-session', '-t', 'Notes'])


def _fzf_open(args):
    # Fuzzy-find and open a file or cd into a directory (bound to Ctrl+e)
    home = $HOME
    find = subprocess.run(
        [
            'find', f'{home}/Downloads', f'{home}/Documents',
            '-maxdepth', '8',
            '(', '-type', 'f', '-o', '-type', 'd', ')',
        ],
        capture_output=True, text=True,
    )
    candidates = [line for line in find.stdout.splitlines() if line.strip()]
    if not candidates:
        return

    fzf = subprocess.run(
        [
            'fzf',
            '--preview', 'bat --style=numbers --color=always --line-range=:500 {}',
            '--preview-window', 'right:60%',
        ],
        input='\n'.join(candidates),
        capture_output=True, text=True,
    )
    selected = fzf.stdout.strip()
    if not selected:
        return

    if os.path.isdir(selected):
        os.chdir(selected)
    else:
        subprocess.run(['nvim', selected])


def _ollama_up(args):
    # Start ollama with tuned env (long context, q4 KV cache, exposed on LAN)
    env = {
        **os.environ,
        'OLLAMA_CONTEXT_LENGTH': '100000',
        'OLLAMA_KV_CACHE_TYPE': 'q4_0',
        'OLLAMA_HOST': '0.0.0.0:11434',
        'OLLAMA_MAX_LOADED_MODELS': '3',
    }
    subprocess.run(['ollama', 'serve'], env=env)


def _opencode_up(args):
    # Launch opencode pointed at the local ollama
    env = {**os.environ, 'OLLAMA_HOST': 'http://localhost:11434'}
    subprocess.run(['opencode', *args], env=env)


def _openwebui_up(args):
    # (Re)deploy the open-webui docker container
    subprocess.run([
        'sudo', 'docker', 'run',
        '-d',
        '--name', 'open-webui',
        '--restart', 'unless-stopped',
        '-p', '3000:8080',
        '--add-host=host.docker.internal:host-gateway',
        '-e', 'OLLAMA_BASE_URL=http://host.docker.internal:11434',
        '-e', 'ENABLE_RAG_WEB_SEARCH=true',
        '-e', 'RAG_WEB_SEARCH_ENGINE=searxng',
        '-e', 'SEARXNG_QUERY_URL=https://search.ramoul.org/search?q=<query>',
        '-e', 'RAG_WEB_SEARCH_RESULT_COUNT=3',
        '-e', 'RAG_WEB_SEARCH_CONCURRENT_REQUESTS=10',
        '-v', 'open-webui:/app/backend/data',
        'ghcr.io/open-webui/open-webui:main',
    ])


aliases['xopen'] = _xopen
aliases['notes'] = _notes
aliases['fzf-open'] = _fzf_open
aliases['ollama-up'] = _ollama_up
aliases['opencode-up'] = _opencode_up
aliases['openwebui-up'] = _openwebui_up
