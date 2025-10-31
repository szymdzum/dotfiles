# Tools Module
# Development tool configurations with optimized loading

# === NVM (Node Version Manager) - Lazy Loading ===
export NVM_DIR="$HOME/.nvm"
typeset -g __NVM_LAZY_LOADED=0

__nvm_lazy_load() {
  (( __NVM_LAZY_LOADED )) && return
  __NVM_LAZY_LOADED=1
  # Remove wrappers to avoid recursion
  unset -f nvm node npm npx yarn pnpm 2>/dev/null
  # Load NVM without auto-switching versions yet
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    . "$NVM_DIR/nvm.sh" --no-use
  fi
  # Optional completions (cheap, but keep lazy too)
  [[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"
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

# Wrappers: load NVM on first use, then delegate to real commands
nvm()  { __nvm_lazy_load; command nvm "$@"; }
node() { __nvm_lazy_load; command node "$@"; }
npm()  { __nvm_lazy_load; command npm "$@"; }
npx()  { __nvm_lazy_load; command npx "$@"; }

# Yarn/Pnpm via corepack when available, after loading NVM
yarn() { __nvm_lazy_load; __nvm_corepack_exec yarn "$@"; }
pnpm() { __nvm_lazy_load; __nvm_corepack_exec pnpm "$@"; }

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
