# 🏠 Dotfiles

My personal development environment configuration files.

## 📂 Structure

```
dotfiles/
├── 🐚 shell/          # Shell configuration (agent-optimized)
│   ├── .zshrc         # Zsh configuration with modern aliases
│   ├── modules/       # Modular shell configs
│   ├── bat/           # Bat syntax highlighting config
│   └── ripgrep/       # Ripgrep search config
├── ✏️  zed/            # Zed editor configuration
│   ├── settings.json  # Zed editor settings
│   ├── keymap.json    # Zed editor keybindings
│   └── tasks.json     # Zed editor tasks
├── 🗃️  git/            # Git configuration (agent-optimized)
│   ├── gitconfig       # Agent-optimized git config
│   └── gitconfig-work  # Work identity config
├── 🐙 gh/             # GitHub CLI configuration (agent-optimized)
│   ├── config.yml     # gh aliases and settings
│   └── README.md      # Setup guide (hosts.yml stays local)
├── 🦊 glab/           # GitLab CLI configuration (agent-optimized)
│   ├── aliases.yml    # glab aliases
│   ├── config.yml     # Template config (tokens stay local)
│   └── README.md      # Setup guide
├── 📦 install.sh      # Installation script
├── 📘 AGENTS.md       # AI assistant guidance (universal standard)
├── 📘 CLAUDE.md       # Claude Code specific guidance
└── 📖 README.md       # This file
```

## ⚡ Quick Install

```bash
# Clone the repository
git clone <repository-url> ~/Developer/dotfiles
cd ~/Developer/dotfiles

# Run the installation script
./install.sh
```

## 🛠️ Manual Installation

If you prefer to install components individually:

```bash
# Shell configuration
ln -sf ~/Developer/dotfiles/shell/.zshrc ~/.zshrc
ln -sf ~/Developer/dotfiles/zed/* ~/.config/zed/
# Zed editor configuration
mkdir -p ~/.config/zed
ln -sf ~/Developer/.dotfiles/zed/* ~/.config/zed/
```

## ✨ Features

### Shell (.zshrc)
- 🎨 **Modern `ls` with `eza`** - Colorful file listings with icons and Git status
- 🚀 **Performance optimized** - Fast startup with cached completions
- 🔧 **Developer aliases** - Git shortcuts, directory navigation, and more
- 🎯 **Smart directory grouping** - Directories listed first for better organization
- 🌈 **Custom color scheme** - Distinct colors for different file types (`.astro` files get purple!)

### Editor (Zed)
- ⚙️ **Optimized settings** for development (zed/settings.json)
- 🎨 **Custom key bindings** (zed/keymap.json)
- 📝 **Development tasks** (zed/tasks.json)

### CLI Tools (Agent-Optimized)
- 🐙 **GitHub CLI (`gh`)** - Custom aliases for compact, parseable output
  - `gh prs`, `gh myprs`, `gh myissues`, `gh checks` - Tab-separated data
  - Uses `--json` and `--template` for structured output
- 🦊 **GitLab CLI (`glab`)** - Consistent pagination and filters
  - `glab mrs`, `glab mymrs`, `glab myissues`, `glab pipes`
  - 20-item pagination reduces API calls
- 🦇 **Bat** - Syntax-highlighted file reading (no pagination for agents)
- 🔍 **Ripgrep** - Smart search with auto-exclusions and custom file types

## 🔄 Updating

```bash
cd ~/Developer/dotfiles
git pull
./install.sh  # Re-run to update symlinks
```

## 🎨 Color Scheme

The terminal uses a custom color scheme for better file recognition:
- 🟣 **Purple** - `.astro` files (Astro components)
- 🟡 **Yellow** - `.ts`, `.js`, `.json` (code files)
- 🟢 **Green** - `.css`, `.scss` (styling files)
- 🔵 **Blue** - Directories and `.html` files
- 🟦 **Cyan** - `.md` files (documentation)

## 🤝 Contributing

Feel free to suggest improvements or report issues!
