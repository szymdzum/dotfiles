# Core ZSH Configuration Module
# Essential settings, exports, PATH, history, and colors

# Skip everything when non-interactive (CI/automation won't thank you, but at least won't curse you)
[[ $- != *i* ]] && return

# Performance optimizations
DISABLE_AUTO_UPDATE="true"        # Oh-My-Zsh update checks are for people with time to burn
DISABLE_MAGIC_FUNCTIONS="true"    # Magic is for Harry Potter, not shells
DISABLE_COMPFIX="true"           # Skip permission paranoia
DISABLE_UNTRACKED_FILES_DIRTY="true"  # Git status should be instant, not contemplative

# Essential directories
export DEVELOPER_HOME="$HOME/Developer"
export REPOS="$HOME/Repos"
export ZDOTDIR="${HOME}"

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

# PATH construction - Organized by priority
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
export LS_COLORS="*.astro=95:*.ts=93:*.js=93:*.json=93:*.md=96:*.css=92:*.scss=92:*.html=94:*.vue=92:*.jsx=93:*.tsx=93:$LS_COLORS"

# Claude Code optimizations
export CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1  # Stay in project root, don't wander
export USE_BUILTIN_RIPGREP=0                       # Use system ripgrep (it's faster)
export BASH_DEFAULT_TIMEOUT_MS=30000              # Reasonable timeout for macOS
export DISABLE_TELEMETRY=1                        # What happens on your Mac, stays on your Mac