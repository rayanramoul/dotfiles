# Aliases.

# Editors
aliases['vim'] = 'nvim'
aliases['vi'] = 'nvim'
aliases['v'] = 'nvim'
aliases['vimdiff'] = ['nvim', '-d']

# File browsing
aliases['yz'] = 'yazi'

# System monitoring
aliases['top'] = 'bpytop'
aliases['htop'] = 'bpytop'
aliases['cat'] = 'bat'

# Git
aliases['ga'] = 'git add'
aliases['gap'] = 'git add --patch'
aliases['gb'] = 'git branch'
aliases['gba'] = 'git branch --all'
aliases['gc'] = 'git commit'
aliases['gca'] = 'git commit --amend --no-edit'
aliases['gce'] = 'git commit --amend'
aliases['gco'] = 'git checkout'
aliases['gcl'] = 'git clone --recursive'
aliases['gd'] = ['git', 'diff', '--output-indicator-new= ', '--output-indicator-old= ']
aliases['gds'] = ['git', 'diff', '--staged', '--output-indicator-new= ', '--output-indicator-old= ']
aliases['gi'] = 'git init'
aliases['gl'] = [
    'git', 'log', '--graph', '--all',
    '--pretty=format:%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n',
]
aliases['gm'] = 'git merge'
aliases['gn'] = 'git checkout -b'
aliases['gp'] = 'git push'
aliases['gr'] = 'git reset'
aliases['gs'] = 'git status --short'
aliases['gu'] = 'git pull'

# Docker
aliases['dps'] = ['docker', 'ps', '--format', 'table {{.Names}}\t{{.Status}}\t{{.Ports}}']
aliases['dl'] = 'docker logs --tail=100'
aliases['dc'] = 'docker compose'

# Tmux
aliases['ta'] = 'tmux attach'
aliases['tl'] = 'tmux list-sessions'
aliases['tn'] = 'tmux new-session -s'

# Chezmoi
aliases['cz'] = 'chezmoi'
aliases['cza'] = 'chezmoi apply'
aliases['czd'] = 'chezmoi diff'
aliases['czl'] = 'chezmoi ls'
aliases['czp'] = 'chezmoi preview'
aliases['czr'] = 'chezmoi resolve'
aliases['czs'] = 'chezmoi status'
aliases['czc'] = 'chezmoi cd'

# Misc
aliases['lg'] = 'lazygit'
aliases['ld'] = 'lazydocker'
