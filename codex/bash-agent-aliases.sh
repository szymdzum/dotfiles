# shellcheck shell=bash
# Bootstrap aliases/functions for non-interactive Codex shells
# Guard to avoid multiple sourcing within a single session
if [ -n "${CODEX_AGENT_ALIASES_LOADED:-}" ]; then
  return 0 2>/dev/null || true
fi
export CODEX_AGENT_ALIASES_LOADED=1

# Ensure critical env vars are present even when Zsh modules are skipped
export DEVELOPER_HOME="${DEVELOPER_HOME:-$HOME/Developer}"
export REPOS="${REPOS:-$HOME/Repos}"

# --- Aliases matching interactive Zsh setup ---
alias ls='eza --color=always --icons --group-directories-first'
alias ll='eza -la --color=always --icons --git --group-directories-first'
alias la='eza -a --color=always --icons --group-directories-first'
alias l='eza -lF --color=always --icons --group-directories-first'
alias lt='eza --tree --color=always --icons --group-directories-first'

alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias dev='cd "$DEVELOPER_HOME"'
alias repos='cd "$REPOS"'
alias docs='cd "$HOME/Documents"'
alias dl='cd "$HOME/Downloads"'
alias dt='cd "$HOME/Desktop"'

alias path='echo "$PATH" | tr ":" "\n"'
alias ports='netstat -tulanp'
alias myip='curl -s ifconfig.me'

alias cl='claude --dangerously-skip-permissions'
alias reload='source ~/.zshrc && echo "Shell reloaded"'
