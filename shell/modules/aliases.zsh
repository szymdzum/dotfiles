# Aliases Module
# Organized aliases by category

# === File Operations (Modern eza edition) ===
alias ls='eza --color=always --icons --group-directories-first'
alias ll='eza -la --color=always --icons --git --group-directories-first'
alias la='eza -a --color=always --icons --group-directories-first'
alias l='eza -lF --color=always --icons --group-directories-first'
alias lt='eza --tree --color=always --icons --group-directories-first'  # Tree view

# Better file operations with feedback
alias cp='cp -i'      # Interactive copy
alias mv='mv -i'      # Interactive move
alias rm='rm -i'      # Interactive remove (safety first)

# === Directory Navigation ===
alias dev="cd $DEVELOPER_HOME"
alias repos="cd $REPOS"
alias docs="cd ~/Documents"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"

# === System Information ===
alias path='echo -e ${PATH//:/\\n}'
alias ports='netstat -tulanp'
alias myip='curl -s ifconfig.me'

# === Development Shortcuts ===
alias serve='python3 -m http.server 8000'  # Quick local server
alias json='python3 -m json.tool'          # Format JSON
alias uuid='uuidgen | tr "[:upper:]" "[:lower:]"'  # Generate lowercase UUID
alias tsc-check="tsc --noEmit --pretty"  # TypeScript check without compilation

# === Python Development ===
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv .venv'
alias activate='source .venv/bin/activate'

# === Claude AI ===
alias cl='claude --dangerously-skip-permissions'

# === Warp Terminal Enhancements ===
alias warp-reset='warp-cli theme reset'  # Reset to default theme
alias clear-all='clear && printf "\\e[3J"'  # True clear (including scrollback)
alias reload='source ~/.zshrc && echo "🔄 Shell reloaded"'

# === Network Utilities ===
alias ping='ping -c 5'  # Limit ping to 5 packets
alias wget='wget -c'     # Resume downloads by default

# === Editor Shortcuts ===
# Note: Removed VSCode aliases since user prefers Zed

# === Git Enhancements ===
# Note: Oh-My-Zsh git plugin provides most git aliases
# Keeping only custom ones not provided by Oh-My-Zsh
alias glog='git log --oneline --graph --decorate'