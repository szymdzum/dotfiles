# Tools Module
# Development tool configurations with optimized loading

# === NVM (Node Version Manager) - Lazy Loading ===
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # Lazy load for faster startup
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Lazy load NVM
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}

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
