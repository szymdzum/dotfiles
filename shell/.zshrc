# Modular ZSH Configuration
# This is the main .zshrc file that loads all modules from shell/modules/
#
# Module loading order is important:
# 1. core.zsh - Essential settings and exports
# 2. performance.zsh - Completion system and caching
# 3. prompt.zsh - Oh-My-Zsh and theme configuration  
# 4. tools.zsh - Development tool configurations
# 5. aliases.zsh - All aliases
# 6. functions.zsh - Custom functions

# Get the directory where this .zshrc file is located
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Developer/dotfiles}"
MODULES_DIR="$DOTFILES_DIR/shell/modules"

# Load core modules in order
source "$MODULES_DIR/core.zsh"
source "$MODULES_DIR/performance.zsh"
source "$MODULES_DIR/prompt.zsh"
source "$MODULES_DIR/tools.zsh"
source "$MODULES_DIR/aliases.zsh"
source "$MODULES_DIR/functions.zsh"

# Load private environment variables (API keys, secrets)
[ -f ~/.env.secrets ] && source ~/.env.secrets

# Load local machine-specific configurations
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Load work-specific configurations
[ -f ~/.zshrc.work ] && source ~/.zshrc.work
alias chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# Chrome alias for headless mode
alias chrome='/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
