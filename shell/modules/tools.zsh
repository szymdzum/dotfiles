# Tools Module
# Development tool configurations with optimized loading

# === Ripgrep Configuration ===
export RIPGREP_CONFIG_PATH="$DOTFILES_DIR/shell/ripgrep/ripgreprc"

# === NVM (Node Version Manager) - Lazy Loading ===
export NVM_DIR="$HOME/.nvm"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  __nvm_last_corepack_node=""

  __nvm_enable_corepack_once() {
    command -v corepack >/dev/null 2>&1 || return 0
    local current_node
    current_node="$(node -v 2>/dev/null)" || return 0
    if [[ "$__nvm_last_corepack_node" == "$current_node" ]]; then
      return 0
    fi
    corepack enable >/dev/null 2>&1
    __nvm_last_corepack_node="$current_node"
  }

  __nvm_loaded=0
  nvm() {
    if (( __nvm_loaded == 0 )); then
      unset -f nvm
      . "$NVM_DIR/nvm.sh"
      [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"
      functions -c nvm __nvm_real
      __nvm_loaded=1
      # Wrap real nvm so corepack is enabled whenever the active Node changes.
      nvm() {
        __nvm_real "$@"
        local status=$?
        __nvm_enable_corepack_once
        return $status
      }
    fi
    nvm "$@"
  }

  load-nvmrc() {
    # Ensure nvm is initialised before we look for .nvmrc
    nvm --version >/dev/null 2>&1 || return
    typeset -f nvm_find_nvmrc >/dev/null 2>&1 || return
    local nvmrc_path
    nvmrc_path="$(nvm_find_nvmrc 2>/dev/null)"
    if [[ -z "$nvmrc_path" ]]; then
      return
    fi

    local desired_version
    desired_version="$(<"$nvmrc_path")"
    local current_version
    current_version="$(nvm current 2>/dev/null)"

    if [[ "$desired_version" != "$current_version" ]]; then
      nvm use --silent "$desired_version" >/dev/null 2>&1
    fi
  }

  if [[ -o interactive ]]; then
    autoload -U add-zsh-hook
    add-zsh-hook chpwd load-nvmrc
    load-nvmrc
  fi
fi

# === PyEnv (Python Version Manager) - Lazy Loading ===
# Check if pyenv is installed before configuring
if command -v pyenv &> /dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"

  # Lazy load pyenv
  pyenv() {
    eval "$(command pyenv init -)"
    pyenv "$@"
  }
fi
