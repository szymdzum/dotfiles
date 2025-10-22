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

# Prefer the active NVM Node version for non-interactive shells so CLI agents
# see the same toolchain version as interactive Zsh sessions.
if [ -n "${NVM_BIN:-}" ]; then
  PATH=":$PATH:"
  PATH="${PATH//:$NVM_BIN:/:}"
  PATH="${PATH#:}"
  PATH="${PATH%:}"
  PATH="$NVM_BIN:$PATH"
  export PATH
elif [ -s "${NVM_DIR:-$HOME/.nvm}/alias/default" ]; then
  _nvm_alias_base_dir="${NVM_DIR:-$HOME/.nvm}/alias"
  if read -r _nvm_default_version <"${_nvm_alias_base_dir}/default"; then
    _nvm_default_version="${_nvm_default_version%%[[:space:]]*}"
    _nvm_resolved_version="$_nvm_default_version"
    _nvm_iteration=0
    while [ $_nvm_iteration -lt 2 ] && [ -n "$_nvm_resolved_version" ]; do
      _nvm_iteration=$((_nvm_iteration + 1))
      _nvm_candidate_version="${_nvm_resolved_version#node-}"
      _nvm_candidate_version="${_nvm_candidate_version#v}"
      for _nvm_candidate in \
        "${NVM_DIR:-$HOME/.nvm}/versions/node/v${_nvm_candidate_version}/bin" \
        "${NVM_DIR:-$HOME/.nvm}/versions/node/${_nvm_candidate_version}/bin"
      do
        if [ -d "$_nvm_candidate" ]; then
          NVM_BIN="$_nvm_candidate"
          PATH=":$PATH:"
          PATH="${PATH//:$NVM_BIN:/:}"
          PATH="${PATH#:}"
          PATH="${PATH%:}"
          PATH="$NVM_BIN:$PATH"
          export NVM_BIN PATH
          break 2
        fi
      done

      case "$_nvm_resolved_version" in
        node|lts/*)
          if read -r _nvm_followed_version <"${_nvm_alias_base_dir}/${_nvm_resolved_version}"; then
            _nvm_resolved_version="${_nvm_followed_version%%[[:space:]]*}"
            continue
          fi
          ;;
      esac
      break
    done
  fi
  unset _nvm_alias_base_dir _nvm_default_version _nvm_resolved_version _nvm_iteration _nvm_candidate _nvm_candidate_version _nvm_followed_version
fi

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
