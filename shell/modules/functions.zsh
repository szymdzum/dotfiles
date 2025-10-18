# Functions Module
# Custom shell functions

# Create directory and enter it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Backup file with timestamp
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

# Quick git add + commit with branch context display
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

# Enhanced directory navigation with context
work() {
  if [ -z "$1" ]; then
    cd "$DEVELOPER_HOME" && ls -la
  else
    cd "$DEVELOPER_HOME/$1" 2>/dev/null || cd "$REPOS/$1" 2>/dev/null || echo "Project '$1' not found"
  fi
  pwd
}