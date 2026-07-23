#!/bin/bash

# Install standalone zsh plugins to replace oh-my-zsh plugins

echo "Installing standalone zsh plugins..."

# Create directory for plugins
mkdir -p ~/.local/share/zsh-plugins

# Install zsh-autosuggestions
if [ ! -d ~/.zsh-autosuggestions ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh-autosuggestions
else
    echo "zsh-autosuggestions already installed"
fi

# Install zsh-syntax-highlighting
if [ ! -d ~/.zsh-syntax-highlighting ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting already installed"
fi

# Install z (jump around)
if [ ! -f ~/.z.sh ]; then
    echo "Installing z (jump around)..."
    curl -fsSL https://raw.githubusercontent.com/rupa/z/master/z.sh -o ~/.z.sh
else
    echo "z already installed"
fi

# Install fzf-tab
if [ ! -d ~/.fzf-tab ]; then
    echo "Installing fzf-tab..."
    git clone https://github.com/Aloxaf/fzf-tab ~/.fzf-tab
else
    echo "fzf-tab already installed"
fi

echo "Plugin installation complete!"
echo ""
echo "Note: The new .zshrc will automatically load these plugins when available."
echo "You can now restart your shell or run 'source ~/.zshrc' to use the new configuration." 