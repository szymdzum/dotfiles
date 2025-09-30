#!/bin/bash

# Dotfiles Installation Script
# Symlinks configuration files from this dotfiles directory to their proper locations

set -e

# Parse command line arguments
DRY_RUN=false
for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            echo "Dotfiles Installation Script"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run    Show what would be installed without making changes"
            echo "  --help, -h   Show this help message"
            echo ""
            echo "This script will:"
            echo "  • Symlink shell configuration (.zshrc)"
            echo "  • Symlink Zed editor configuration"
            echo "  • Symlink Git configuration (.gitconfig)"
            echo "  • Create backups of existing files"
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}👀 DRY RUN MODE - No changes will be made${NC}"
fi

echo -e "${BLUE}🏠 Installing dotfiles from: ${DOTFILES_DIR}${NC}"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Validate source exists
    if [[ ! -e "$source" ]]; then
        echo -e "${RED}❌ Error: Source does not exist: $source${NC}"
        return 1
    fi
    
    if [ "$DRY_RUN" = true ]; then
        if [[ -L "$target" ]]; then
            echo -e "${YELLOW}[DRY RUN] Would remove existing symlink: $target${NC}"
        elif [[ -f "$target" ]] || [[ -d "$target" ]]; then
            echo -e "${YELLOW}[DRY RUN] Would backup existing file: $target${NC}"
        fi
        echo -e "${BLUE}[DRY RUN] Would link: $target -> $source${NC}"
        return 0
    fi
    
    if [[ -L "$target" ]]; then
        echo -e "${YELLOW}⚠️  Removing existing symlink: $target${NC}"
        rm "$target" || {
            echo -e "${RED}❌ Failed to remove symlink: $target${NC}"
            return 1
        }
    elif [[ -f "$target" ]] || [[ -d "$target" ]]; then
        echo -e "${YELLOW}📦 Backing up existing file: $target${NC}"
        mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)" || {
            echo -e "${RED}❌ Failed to backup: $target${NC}"
            return 1
        }
    fi
    
    ln -s "$source" "$target" || {
        echo -e "${RED}❌ Failed to create symlink: $target${NC}"
        return 1
    }
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

# Install Git configuration
echo -e "${BLUE}🗃️  Installing Git configuration...${NC}"
if [[ -f "$DOTFILES_DIR/git/.gitconfig" ]]; then
    create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    echo -e "${YELLOW}⚠️  Remember to create ~/.gitconfig.local with your personal details${NC}"
    echo -e "${BLUE}   Template: $DOTFILES_DIR/git/.gitconfig.local.example${NC}"
fi

# Make sure the shell configuration is sourced
if [ "$DRY_RUN" = false ]; then
    echo -e "${BLUE}🔄 Reloading shell configuration...${NC}"
    if [[ "$SHELL" == */zsh ]]; then
        source ~/.zshrc || true
    fi
fi

# Verification function
verify_installation() {
    echo -e "\n${BLUE}🔍 Verifying installation...${NC}"
    local all_ok=true
    
    # Check shell config
    if [[ -L "$HOME/.zshrc" ]] && [[ -e "$HOME/.zshrc" ]]; then
        echo -e "${GREEN}✅ Shell configuration: OK${NC}"
    else
        echo -e "${RED}❌ Shell configuration: FAILED${NC}"
        all_ok=false
    fi
    
    # Check Git config
    if [[ -L "$HOME/.gitconfig" ]] && [[ -e "$HOME/.gitconfig" ]]; then
        echo -e "${GREEN}✅ Git configuration: OK${NC}"
    else
        echo -e "${YELLOW}⚠️  Git configuration: Not installed${NC}"
    fi
    
    # Check Zed config
    if [[ -L "$HOME/.config/zed/settings.json" ]] && [[ -e "$HOME/.config/zed/settings.json" ]]; then
        echo -e "${GREEN}✅ Zed configuration: OK${NC}"
    else
        echo -e "${YELLOW}⚠️  Zed configuration: Not installed${NC}"
    fi
    
    if [ "$all_ok" = true ]; then
        return 0
    else
        return 1
    fi
}

if [ "$DRY_RUN" = false ]; then
    verify_installation
fi

echo -e "\n${GREEN}🎉 Dotfiles installation complete!${NC}"

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}👀 This was a dry run. Run without --dry-run to actually install.${NC}"
else
    echo -e "${BLUE}💡 Run 'source ~/.zshrc' or restart your terminal to apply changes.${NC}"
    echo -e "${BLUE}🔑 Edit secrets: 'zed ~/.env.secrets' or 'zed ~/.zshrc.local'${NC}"
    
    # Optional next steps
    if [[ ! -f "$HOME/.gitconfig.local" ]]; then
        echo -e "\n${YELLOW}📝 Next steps:${NC}"
        echo -e "  1. Create ~/.gitconfig.local with your Git details:"
        echo -e "     ${BLUE}cp $DOTFILES_DIR/git/.gitconfig.local.example ~/.gitconfig.local${NC}"
        echo -e "  2. (Optional) Install pre-commit hook for secret scanning:"
        echo -e "     ${BLUE}cp $DOTFILES_DIR/git/hooks/pre-commit .git/hooks/pre-commit${NC}"
    fi
fi
