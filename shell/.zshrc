# macOS Claude Code .zshrc - Performance First, Aesthetics When Convenient
# Because your terminal should load faster than your morning patience expires

# Skip everything when non-interactive (CI/automation won't thank you, but at least won't curse you)
[[ $- != *i* ]] && return

# macOS Performance Optimizations - No time for startup theater
DISABLE_AUTO_UPDATE="true"        # Oh-My-Zsh update checks are for people with time to burn
DISABLE_MAGIC_FUNCTIONS="true"    # Magic is for Harry Potter, not shells
DISABLE_COMPFIX="true"           # Skip permission paranoia
DISABLE_UNTRACKED_FILES_DIRTY="true"  # Git status should be instant, not contemplative

# Completion system - Cache like your performance depends on it (because it does)
autoload -Uz compinit
# Only rebuild completions once per day, like a sane person
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"
else
    compinit -C -d "${ZDOTDIR:-$HOME}/.zcompdump"
fi


# ZSH Configuration
export ZSH="$HOME/.oh-my-zsh"
export ZDOTDIR="${HOME}"
export ZSH_CACHE_DIR="${HOME}/.cache/oh-my-zsh"

# Developer Environment
export DEVELOPER_HOME="$HOME/Developer"
export REPOS="$HOME/Repos"

# Create cache directory if it doesn't exist
[[ ! -d "$ZSH_CACHE_DIR/completions" ]] && mkdir -p "$ZSH_CACHE_DIR/completions"

# Theme Configuration
ZSH_THEME="minimal"

# Plugin Configuration
plugins=(
  git              # Git aliases and functions
  zsh-autosuggestions
)

# Load Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Autosuggestions performance tweaks - Because suggestions shouldn't need suggestions
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Claude Code optimizations - The reason we're here
export CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1  # Stay in project root, don't wander
export USE_BUILTIN_RIPGREP=0                       # Use system ripgrep (it's faster)
export BASH_DEFAULT_TIMEOUT_MS=30000              # Reasonable timeout for macOS
export DISABLE_TELEMETRY=1                        # What happens on your Mac, stays on your Mac
# History settings - Because forgetting commands is for amateurs
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

path=(
  $DEVELOPER_HOME/Scripts
  $HOME/.local/bin
  $HOME/.deno/bin
  $HOME/.cargo/bin
  /opt/homebrew/bin
  /opt/homebrew/sbin
  $path
)

export PATH

# Color support - Force terminal to show colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export FORCE_COLOR=1
export COLORTERM=truecolor

# Custom colors for file extensions (LS_COLORS)
# Format: extension=color_code
# Color codes: 30-37 (foreground), 90-97 (bright foreground)
# 31=red, 32=green, 33=yellow, 34=blue, 35=magenta, 36=cyan, 37=white
# 91=bright red, 92=bright green, 93=bright yellow, 94=bright blue, 95=bright magenta, 96=bright cyan, 97=bright white
export LS_COLORS="*.astro=95:*.ts=93:*.js=93:*.json=93:*.md=96:*.css=92:*.scss=92:*.html=94:*.vue=92:*.jsx=93:*.tsx=93:$LS_COLORS"

# Essential aliases - Modern eza edition for better colors and icons
alias ls='eza --color=always --icons --group-directories-first'
alias ll='eza -la --color=always --icons --git --group-directories-first'
alias la='eza -a --color=always --icons --group-directories-first'
alias l='eza -lF --color=always --icons --group-directories-first'
alias lt='eza --tree --color=always --icons --group-directories-first'  # Tree view
alias gs="git status --porcelain"      # Machine readable git status
alias gd="git diff --no-pager"         # Git diff that doesn't hijack your terminal
alias gb="git branch --format='%(refname:short)'"  # Clean branch list
alias tsc-check="tsc --noEmit --pretty"  # TypeScript check without compilation
alias code.="code ."                   # Open current directory in VS Code (muscle memory)

# Directory Shortcuts
alias dev="cd $DEVELOPER_HOME"
alias repos="cd $REPOS"
alias docs="cd ~/Documents"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"

# System Information
alias path='echo -e ${PATH//:/\\n}'
alias ports='netstat -tulanp'
alias myip='curl -s ifconfig.me'

# Git Enhancements
alias gs='git status'
alias gst='git status'
alias ga='git add'
alias gc='git commit'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gb='git branch'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate'

alias cl='claude --dangerously-skip-permissions'

# Warp-specific enhancements
alias warp-reset='warp-cli theme reset'  # Reset to default theme
alias clear-all='clear && printf "\e[3J"'  # True clear (including scrollback)
alias reload='source ~/.zshrc && echo "🔄 Shell reloaded"'

# Better file operations with feedback
alias cp='cp -i'      # Interactive copy
alias mv='mv -i'      # Interactive move
alias rm='rm -i'      # Interactive remove (safety first)

# Network utilities
alias ping='ping -c 5'  # Limit ping to 5 packets
alias wget='wget -c'     # Resume downloads by default

# Development shortcuts
alias serve='python3 -m http.server 8000'  # Quick local server
alias json='python3 -m json.tool'          # Format JSON
alias uuid='uuidgen | tr "[:upper:]" "[:lower:]"'  # Generate lowercase UUID

# Python Development
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv .venv'
alias activate='source .venv/bin/activate'
# Create directory and enter it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Backup file
backup() {
  cp "$1"{,.backup.$(date +%Y%m%d_%H%M%S)}
  echo "✓ Created backup: $1.backup.$(date +%Y%m%d_%H%M%S)"
}

# Search with ripgrep or fallback to grep
search() {
  if command -v rg &> /dev/null; then
    rg "$@"
  else
    grep -r "$@" .
  fi
}

# Quick project setup
project() {
  if [ -z "$1" ]; then
    echo "Usage: project <name>"
    return 1
  fi
  mkdir -p "$DEVELOPER_HOME/$1" && cd "$DEVELOPER_HOME/$1"
  git init
  echo "# $1" > README.md
  echo "✅ Project '$1' created and initialized"
}

# Smart git commit with branch info
commit() {
  if [ -z "$1" ]; then
    echo "Usage: commit <message>"
    return 1
  fi
  local branch=$(git branch --show-current 2>/dev/null)
  if [ -n "$branch" ]; then
    git add . && git commit -m "$1" && echo "📝 Committed to branch: $branch"
  else
    echo "❌ Not in a git repository"
  fi
}

# File info with size and permissions
info() {
  if [ -z "$1" ]; then
    ls -laFG
  else
    ls -laFG "$1" && file "$1" 2>/dev/null
  fi
}

# Find and open in Zed (your preferred editor)
fz() {
  if [ -z "$1" ]; then
    echo "Usage: fz <pattern>"
    return 1
  fi
  local file=$(find . -name "*$1*" -type f | head -1)
  if [ -n "$file" ]; then
    zed "$file"
  else
    echo "File matching '$1' not found"
  fi
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # Lazy load for faster startup
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Lazy load NVM
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# PyEnv (Python Version Manager)
if command -v pyenv &> /dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  eval "$(pyenv init -)"
fi

# Load private environment variables (API keys, secrets)
[ -f ~/.env.secrets ] && source ~/.env.secrets

# Load local machine-specific configurations
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Load work-specific configurations
[ -f ~/.zshrc.work ] && source ~/.zshrc.work

# Add completions to fpath
fpath=(
  $ZSH_CACHE_DIR/completions
  $fpath
)

# pnpm
export PNPM_HOME="/Users/szymondzumak/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

PATH=~/.console-ninja/.bin:$PATH

# Warp-enhanced development workflow
# Test runner with output formatting
test() {
  echo "🧪 Running tests..."
  if [ -f "package.json" ]; then
    npm test
  elif [ -f "Cargo.toml" ]; then
    cargo test
  elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    python -m pytest
  else
    echo "⚠️ No test configuration found"
  fi
}

# Enhanced directory navigation with context
work() {
  if [ -z "$1" ]; then
    cd "$DEVELOPER_HOME" && ls -la
  else
    cd "$DEVELOPER_HOME/$1" 2>/dev/null || cd "$REPOS/$1" 2>/dev/null || echo "Project '$1' not found"
  fi
  pwd
}

# System monitor (Warp-friendly output)
monitor() {
  echo "📊 System Status:"
  echo "CPU: $(top -l 1 | grep 'CPU usage' | awk '{print $3}' | cut -d% -f1)%"
  echo "Memory: $(memory_pressure | grep 'System-wide memory free percentage' | awk '{print $5}' || echo 'N/A')"
  echo "Disk: $(df -h / | tail -1 | awk '{print $5}')"
  echo "Load: $(uptime | awk '{print $(NF-2), $(NF-1), $NF}')"
}
