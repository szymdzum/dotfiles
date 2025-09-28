# Performance Optimization Module
# Completion system, caching, and startup optimizations

# Completion system - Cache like your performance depends on it (because it does)
autoload -Uz compinit

# Only rebuild completions once per day, like a sane person
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"
else
    compinit -C -d "${ZDOTDIR:-$HOME}/.zcompdump"
fi

# ZSH cache directory setup
export ZSH_CACHE_DIR="${HOME}/.cache/oh-my-zsh"
[[ ! -d "$ZSH_CACHE_DIR/completions" ]] && mkdir -p "$ZSH_CACHE_DIR/completions"

# Add completions to fpath
fpath=(
  $ZSH_CACHE_DIR/completions
  $fpath
)