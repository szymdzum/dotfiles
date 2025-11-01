# Tools Module
# Development tool configurations with optimized loading

# === NVM (Node Version Manager) - Lazy Loading ===
export NVM_DIR="$HOME/.nvm"
typeset -g __NVM_LAZY_LOADED=0

__nvm_lazy_load() {
  (( __NVM_LAZY_LOADED )) && return
  __NVM_LAZY_LOADED=1
  # Remove wrapper functions FIRST to avoid recursion
  unset -f nvm node npm npx yarn pnpm 2>/dev/null
  # Load NVM and activate default version
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    . "$NVM_DIR/nvm.sh"
    # Use default version or last used version
    nvm use default --silent 2>/dev/null || nvm use node --silent 2>/dev/null || true
  fi
  # Optional completions
  [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"
  # Ensure NVM's node is used even if Homebrew node is installed
  # NVM should have added its path, but verify it's actually first
  if command -v node >/dev/null 2>&1; then
    local nvm_node_path="$(command -v node)"
    if [[ "$nvm_node_path" == "$NVM_DIR"* ]]; then
      # NVM node is active, all good
      return 0
    fi
  fi
  # If we get here, Homebrew node might be first - issue a warning
  echo "⚠️  Warning: NVM loaded but Homebrew node may be active. Run 'brew uninstall node' to use NVM exclusively." >&2
}

# Use corepack directly to avoid enabling costs unless necessary
__nvm_corepack_exec() {
  # This uses corepack as a launcher so we don't need `corepack enable`.
  if command -v corepack >/dev/null 2>&1; then
    command corepack "$@"
    return $?
  fi
  # Fallback to the underlying command if corepack isn't available
  command "$@"
}

# .nvmrc auto-use: only load NVM when entering a dir with .nvmrc
autoload -Uz add-zsh-hook
__nvm_auto_use_on_chpwd() {
  if [[ -f .nvmrc ]]; then
    __nvm_lazy_load
    nvm use --silent >/dev/null 2>&1 || true
  fi
}
add-zsh-hook chpwd __nvm_auto_use_on_chpwd
# Do it once for the starting directory
__nvm_auto_use_on_chpwd

# Wrappers: trigger lazy-loading on first use
# The wrappers unset themselves and NVM's functions take over
nvm()  { __nvm_lazy_load; nvm "$@"; }
node() { __nvm_lazy_load; node "$@"; }
npm()  { __nvm_lazy_load; npm "$@"; }
npx()  { __nvm_lazy_load; npx "$@"; }
yarn() { __nvm_lazy_load; yarn "$@"; }
pnpm() { __nvm_lazy_load; pnpm "$@"; }

# === PyEnv (Python Version Manager) - Lazy Loading ===
export PYENV_ROOT="${PYENV_ROOT:-/opt/homebrew/opt/pyenv}"
typeset -g __PYENV_LAZY_LOADED=0

__pyenv_lazy_load() {
  (( __PYENV_LAZY_LOADED )) && return
  __PYENV_LAZY_LOADED=1
  # Remove wrappers to avoid recursion
  unset -f pyenv python pip 2>/dev/null
  if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
  fi
}

# Wrapper functions
pyenv() { __pyenv_lazy_load; command pyenv "$@"; }
python() { __pyenv_lazy_load; command python "$@"; }
pip() { __pyenv_lazy_load; command pip "$@"; }
