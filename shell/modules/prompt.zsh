# shellcheck shell=bash
# Prompt and Theme Module
# Oh-My-Zsh configuration, theme, and plugins

# Oh-My-Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Theme configuration
ZSH_THEME="minimal"

# Plugin configuration
plugins=(
  git              # Git aliases and functions
  zsh-autosuggestions
)

# Load Oh My Zsh
source "$ZSH"/oh-my-zsh.sh

# Autosuggestions performance tweaks - Because suggestions shouldn't need suggestions
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_STRATEGY=(history completion)