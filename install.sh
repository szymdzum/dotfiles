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
    # Only symlink specific config files, not backups
    for file in settings.json keymap.json tasks.json; do
        if [[ -f "$DOTFILES_DIR/zed/$file" ]]; then
            create_symlink "$DOTFILES_DIR/zed/$file" "$HOME/.config/zed/$file"
        fi
    done
fi

# Install Codex configuration
echo -e "${BLUE}🤖 Installing Codex configuration...${NC}"
if [[ -f "$DOTFILES_DIR/codex/config.toml" ]]; then
    mkdir -p ~/.codex
    create_symlink "$DOTFILES_DIR/codex/config.toml" "$HOME/.codex/config.toml"
fi

# Install Gemini CLI configuration
echo -e "${BLUE}💎 Installing Gemini CLI configuration...${NC}"
if [[ -f "$DOTFILES_DIR/gemini/settings.json" ]]; then
    mkdir -p ~/.gemini
    create_symlink "$DOTFILES_DIR/gemini/settings.json" "$HOME/.gemini/settings.json"
fi

# Install Git configuration
echo -e "${BLUE}🔧 Installing Git configuration...${NC}"
if [[ -f "$DOTFILES_DIR/git/gitconfig" ]]; then
    create_symlink "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
else
    echo -e "${YELLOW}⚠️  No git config found (skipping)${NC}"
fi

# Install Ripgrep configuration
echo -e "${BLUE}🔍 Installing Ripgrep configuration...${NC}"
if [[ -f "$DOTFILES_DIR/ripgrep/ripgreprc" ]]; then
    # Ripgrep doesn't need a directory, just the config file referenced by env var
    # The env var is set in shell/modules/tools.zsh
    echo -e "${GREEN}✅ Ripgrep config will be loaded via RIPGREP_CONFIG_PATH${NC}"
else
    echo -e "${YELLOW}⚠️  No ripgrep config found (skipping)${NC}"
fi

# Install Claude Code CLI configuration
echo -e "${BLUE}🤖 Installing Claude Code CLI configuration...${NC}"
if [[ -f "$DOTFILES_DIR/claude/settings.json" ]]; then
    mkdir -p ~/.claude
    create_symlink "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
fi

# Install SSH configuration (if it exists)
echo -e "${BLUE}🔐 Installing SSH configuration...${NC}"
if [[ -d "$DOTFILES_DIR/.ssh" ]]; then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh

    # Symlink SSH config if it exists
    if [[ -f "$DOTFILES_DIR/.ssh/config" ]]; then
        create_symlink "$DOTFILES_DIR/.ssh/config" "$HOME/.ssh/config"
        chmod 600 "$HOME/.ssh/config"
        echo -e "${GREEN}✅ SSH config installed${NC}"
    fi

    # Copy public keys (don't symlink for security)
    if ls "$DOTFILES_DIR/.ssh/"*.pub >/dev/null 2>&1; then
        echo -e "${BLUE}📋 Copying SSH public keys...${NC}"
        cp "$DOTFILES_DIR/.ssh/"*.pub "$HOME/.ssh/"
        chmod 644 "$HOME/.ssh/"*.pub
        echo -e "${GREEN}✅ SSH public keys copied${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  No .ssh directory found in dotfiles (skipping)${NC}"
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
