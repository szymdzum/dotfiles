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

# === Claude AI ===
alias cl='claude --dangerously-skip-permissions'

# === Shell Utilities ===
alias reload='source ~/.zshrc && echo "🔄 Shell reloaded"'
