# chezmoi-driving recipes. Run `just` (no args) to list.
# Requires: just (in packages.yaml global), chezmoi.

set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# Default: list recipes
_default:
    @just --list

# Apply pending source changes to $HOME
apply:
    chezmoi apply

# Show pending diff (source vs target)
diff:
    chezmoi diff

# Apply non-interactively, forcing where needed
force:
    chezmoi apply --force --less-interactive --keep-going

# Bootstrap a fresh machine — clone repo + first apply.
# Usage: just bootstrap github:youruser/yourdotfilesrepo
bootstrap REPO:
    chezmoi init --apply {{REPO}}

# Pull upstream + re-apply
update:
    chezmoi update

# Show what chezmoi tracks vs not
status:
    chezmoi status

# List $HOME files chezmoi doesn't manage (first 30 lines)
unmanaged:
    chezmoi unmanaged | head -30

# Edit a file inside the chezmoi source dir
edit FILE:
    chezmoi edit {{FILE}}

# Re-stage a file (target → source)
re-add FILE:
    chezmoi re-add {{FILE}}

# Run the package install script directly (forces re-evaluation)
packages:
    bash "$(chezmoi source-path)/run_onchange_install-packages.sh.tmpl"

# Just runs `topgrade` (system + langs + plugins). See topgrade.toml.
upgrade:
    topgrade
