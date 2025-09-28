#!/bin/bash

# Dotfiles Installation Script
# Symlinks configuration files from this dotfiles directory to their proper locations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}🏠 Installing dotfiles from: ${DOTFILES_DIR}${NC}"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ -L "$target" ]]; then
        echo -e "${YELLOW}⚠️  Removing existing symlink: $target${NC}"
        rm "$target"
    elif [[ -f "$target" ]]; then
        echo -e "${YELLOW}📦 Backing up existing file: $target${NC}"
        mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    ln -s "$source" "$target"
    echo -e "${GREEN}✅ Linked: $target -> $source${NC}"
}

# Create necessary directories
echo -e "${BLUE}📁 Creating necessary directories...${NC}"
mkdir -p ~/.config

# Install shell configuration
echo -e "${BLUE}🐚 Installing shell configuration...${NC}"
create_symlink "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"

# Install Zed editor configuration
echo -e "${BLUE}✏️  Installing Zed configuration...${NC}"
if [[ -d "$DOTFILES_DIR/zed" ]]; then
    mkdir -p ~/.config/zed
    for file in "$DOTFILES_DIR/zed"/*; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            create_symlink "$file" "$HOME/.config/zed/$filename"
        fi
    done
fi

# Make sure the shell configuration is sourced
echo -e "${BLUE}🔄 Reloading shell configuration...${NC}"
if [[ "$SHELL" == */zsh ]]; then
    source ~/.zshrc || true
fi

# Create convenience symlinks for easy access to secret files
echo -e "${BLUE}🔗 Creating convenience symlinks for secret files...${NC}"
cd "$DOTFILES_DIR"
ln -sf ~/.env.secrets ./env.secrets 2>/dev/null || true
ln -sf ~/.zshrc.local ./zshrc.local 2>/dev/null || true
ln -sf ~/.zshrc.work ./zshrc.work 2>/dev/null || true
echo -e "${GREEN}✅ Secret file symlinks created (git-ignored)${NC}"

echo -e "${GREEN}🎉 Dotfiles installation complete!${NC}"
echo -e "${BLUE}💡 Run 'source ~/.zshrc' or restart your terminal to apply changes.${NC}"
echo -e "${BLUE}🔑 Edit secrets easily: 'zed env.secrets' or 'zed zshrc.local'${NC}"
