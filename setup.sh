#!/bin/bash

# setup.sh - Dotfiles Setup Script
# 
# This script sets up the dotfiles by creating symbolic links
# from the repository to the user's home directory.
# It includes error handling and backup functionality.

# Exit on error
set -e

# Directory containing this script (dotfiles repository)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Dotfiles directory: $DOTFILES_DIR"

# Function to create a backup of an existing file
backup_file() {
    local file=$1
    local backup
    backup="${file}.backup.$(date +%Y%m%d%H%M%S)"
    
    if [[ -e "$file" && ! -L "$file" ]]; then
        echo "Backing up $file to $backup"
        mv "$file" "$backup"
    elif [[ -L "$file" ]]; then
        echo "Removing existing symlink: $file"
        rm "$file"
    fi
}

# Function to create symbolic links
create_symlink() {
    local source_file=$1
    local target_file=$2
    
    echo "Creating symlink: $target_file -> $source_file"
    ln -s "$source_file" "$target_file"
}

# Function to set up SSH configuration
setup_ssh() {
    echo "Setting up SSH configuration..."
    
    # Create .ssh directory if it doesn't exist
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    
    # Handle SSH config file
    if [ -f "$DOTFILES_DIR/.ssh/config" ]; then
        backup_file "$HOME/.ssh/config"
        create_symlink "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"
        chmod 600 "$HOME/.ssh/config"
    fi
    
    # Copy public keys
    if ls "$DOTFILES_DIR/.ssh/"*.pub >/dev/null 2>&1; then
        echo "Copying SSH public keys..."
        cp "$DOTFILES_DIR/.ssh/"*.pub "$HOME/.ssh/"
        chmod 644 "$HOME/.ssh/"*.pub
    fi
    
    echo "SSH configuration complete!"
}

# Main setup function
setup() {
    echo "Setting up dotfiles..."
    
    # .zshrc
    echo "Setting up .zshrc"
    backup_file "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"
    
    # Set up SSH configuration
    setup_ssh
    
    # Add additional dotfiles here as needed
    # Example:
    # backup_file "$HOME/.gitconfig"
    # create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
    
    echo "Dotfiles setup complete!"
}

# Run the setup
setup

# Function to set up Zed editor configuration
setup_zed() {
    echo "Setting up Zed editor configuration..."
    
    # Create Zed config directory if it doesn't exist
    local zed_config_dir
    zed_config_dir="$HOME/.config/zed"
    mkdir -p "$zed_config_dir"
    
    # Handle Zed configuration files
    for file in settings.jsonc keymap.jsonc tasks.jsonc; do
        if [[ -f "$DOTFILES_DIR/zed/$file" ]]; then
            echo "Setting up Zed $file..."
            backup_file "$zed_config_dir/$file"
            create_symlink "$DOTFILES_DIR/zed/$file" "$zed_config_dir/$file"
        fi
    done
    
    echo "Zed configuration complete!"
}

# Add VSCode setup to main setup function
setup() {
    echo "Setting up dotfiles..."
    
    # .zshrc
    echo "Setting up .zshrc"
    backup_file "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"
    
    # Set up SSH configuration
    setup_ssh
    
    # Set up Zed configuration
    setup_zed
    
    echo "Dotfiles setup complete!"
}
