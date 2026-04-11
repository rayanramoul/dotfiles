#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# GitHub repository
REPO="https://github.com/rayanramoul/dotfiles"

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/arch-release ]; then
            echo "arch"
        elif [ -f /etc/debian_version ]; then
            echo "debian"
        elif [ -f /etc/fedora-release ]; then
            echo "fedora"
        else
            echo "linux"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Check if chezmoi is installed
check_chezmoi() {
    if command -v chezmoi &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Install chezmoi based on OS
install_chezmoi() {
    local os=$1
    print_info "Installing chezmoi..."
    
    case $os in
        arch)
            if command -v paru &> /dev/null; then
                paru -S --noconfirm chezmoi
            elif command -v yay &> /dev/null; then
                yay -S --noconfirm chezmoi
            elif command -v pacman &> /dev/null; then
                sudo pacman -S --noconfirm chezmoi
            else
                print_error "No package manager found (paru/yay/pacman)"
                return 1
            fi
            ;;
        debian)
            if command -v apt-get &> /dev/null; then
                sudo apt-get update
                sudo apt-get install -y chezmoi
            elif command -v apt &> /dev/null; then
                sudo apt update
                sudo apt install -y chezmoi
            else
                print_error "apt/apt-get not found"
                return 1
            fi
            ;;
        fedora)
            if command -v dnf &> /dev/null; then
                sudo dnf install -y chezmoi
            else
                print_error "dnf not found"
                return 1
            fi
            ;;
        macos)
            if command -v brew &> /dev/null; then
                brew install chezmoi
            else
                print_warning "Homebrew not found. Installing via script..."
                sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
                export PATH="$HOME/.local/bin:$PATH"
            fi
            ;;
        *)
            print_warning "Unknown OS. Installing via script..."
            sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
            export PATH="$HOME/.local/bin:$PATH"
            ;;
    esac
    
    if check_chezmoi; then
        print_success "chezmoi installed successfully"
        return 0
    else
        print_error "Failed to install chezmoi"
        return 1
    fi
}

# Main installation
main() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}          ${GREEN}RayTerm Installer${NC}           ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
    
    # Detect OS
    OS=$(detect_os)
    print_info "Detected OS: $OS"
    
    # Check if chezmoi is installed
    if check_chezmoi; then
        print_success "chezmoi is already installed"
        CHEZMOI_VERSION=$(chezmoi --version | head -n1)
        print_info "Version: $CHEZMOI_VERSION"
    else
        print_warning "chezmoi not found"
        install_chezmoi "$OS" || exit 1
    fi
    
    echo ""
    print_info "Initializing and applying dotfiles from $REPO"
    echo ""
    
    # Check if SSH key exists and GitHub is accessible
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        print_success "GitHub SSH authentication successful"
        REPO_URL="git@github.com:rayanramoul/dotfiles"
    else
        print_warning "GitHub SSH not configured, using HTTPS"
        REPO_URL="$REPO"
    fi
    
    # Apply dotfiles
    if chezmoi init --apply "$REPO_URL"; then
        echo ""
        print_success "Dotfiles applied successfully!"
        echo ""
        print_info "Installing Zsh plugins"
        if [ -x "$HOME/scripts/executable_install_zsh_plugins.sh" ]; then
            if "$HOME/scripts/executable_install_zsh_plugins.sh"; then
                print_success "Zsh plugins installed"
            else
                print_warning "Zsh plugin installation failed"
            fi
        elif [ -x "$HOME/.local/share/chezmoi/scripts/executable_install_zsh_plugins.sh" ]; then
            if "$HOME/.local/share/chezmoi/scripts/executable_install_zsh_plugins.sh"; then
                print_success "Zsh plugins installed"
            else
                print_warning "Zsh plugin installation failed"
            fi
        else
            print_warning "Zsh plugin installer not found"
        fi

        echo ""
        print_info "RayTerm has been installed. You may need to:"
        echo "  • Restart your shell or run: source ~/.zshrc"
        echo "  • Install additional packages with: chezmoi cd && ./run_onchange_install-packages.sh.tmpl"
        echo "  • Restart your window manager/desktop environment"
        echo ""
    else
        echo ""
        print_error "Failed to apply dotfiles"
        exit 1
    fi
}

# Run main function
main

