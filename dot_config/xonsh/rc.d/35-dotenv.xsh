# Auto-source *.env files on cd.
#
# When entering a directory, any *.env file there gets its KEY=VALUE pairs
# loaded into the shell environment. On cd out, those keys are unloaded so
# they don't leak between projects.
#
# Caveats:
#   - No `direnv allow`-style permission gate — every dir's *.env auto-loads.
#     Don't `cd` into untrusted repos without inspecting their *.env first.
#   - Variables defined in the user's shell config get preserved (we only
#     unload keys that *.env set, not keys that pre-existed).
#   - Lines must be `KEY=value` (with optional surrounding quotes). No `export`,
#     no multiline values. `$VAR` and `${VAR}` are expanded at load time against
#     the current environment, so self-referential paths like
#     `PYTHONPATH=${PYTHONPATH}:./src` resolve to a flat string and don't
#     recurse when xonsh later detypes path-type vars.

import glob
import os
import shlex

_dotenv_loaded = {}   # key -> previous value (None if it didn't exist before)


def _dotenv_expand(value, env_lookup):
    # Resolve $VAR / ${VAR} against the live environment so stored values
    # never contain unresolved references (which would recurse in EnvPath).
    def repl(match):
        name = match.group(1) or match.group(2)
        resolved = env_lookup(name)
        if resolved is None:
            return ''
        # xonsh path-type vars come back as EnvPath; stringify with pathsep.
        if isinstance(resolved, (list, tuple)):
            return os.pathsep.join(str(p) for p in resolved)
        return str(resolved)

    import re
    return re.sub(r'\$\{([A-Za-z_][A-Za-z0-9_]*)\}|\$([A-Za-z_][A-Za-z0-9_]*)', repl, value)


def _dotenv_parse(path):
    pairs = {}
    env_lookup = lambda name: __xonsh__.env.get(name, os.environ.get(name))
    with open(path) as fh:
        for raw in fh:
            line = raw.strip()
            if not line or line.startswith('#') or '=' not in line:
                continue
            if line.startswith('export '):
                line = line[len('export '):]
            key, _, value = line.partition('=')
            key = key.strip()
            if not key.isidentifier():
                continue
            try:
                # shlex handles quoted values correctly
                parts = shlex.split(value, posix=True)
                value = parts[0] if parts else ''
            except ValueError:
                continue
            pairs[key] = _dotenv_expand(value, env_lookup)
    return pairs


def _dotenv_apply(directory):
    # Restore any previously-loaded keys.
    for key, prev in _dotenv_loaded.items():
        if prev is None:
            __xonsh__.env.pop(key, None)
        else:
            __xonsh__.env[key] = prev
    _dotenv_loaded.clear()

    # Load whatever *.env files exist in the new dir.
    for path in sorted(glob.glob(os.path.join(directory, '*.env'))):
        for key, value in _dotenv_parse(path).items():
            if key not in _dotenv_loaded:
                _dotenv_loaded[key] = __xonsh__.env.get(key)
            __xonsh__.env[key] = value


@events.on_chdir
def _dotenv_on_chdir(olddir, newdir, **kw):
    _dotenv_apply(newdir)


# Apply once at shell startup for the launch cwd.
_dotenv_apply(os.getcwd())
