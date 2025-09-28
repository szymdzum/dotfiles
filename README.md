# 🏠 Modern macOS Dotfiles

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![macOS](https://img.shields.io/badge/macOS-Compatible-green.svg)](https://www.apple.com/macos/)
[![Shell](https://img.shields.io/badge/Shell-ZSH-orange.svg)](https://www.zsh.org/)
[![Editor](https://img.shields.io/badge/Editor-Zed-purple.svg)](https://zed.dev/)

A modern, performance-focused dotfiles setup for macOS developers featuring modular ZSH configuration, Zed editor integration, and secure secret management.

## ⚡ Quick Start

**One-line installation:**
```bash
git clone https://github.com/szymdzum/dotfiles.git ~/Developer/dotfiles && cd ~/Developer/dotfiles && ./install.sh
```

Or step by step:
```bash
# Clone the repository
git clone https://github.com/szymdzum/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles

# Run the installation script
./install.sh
```

## 📋 Prerequisites

- **macOS** 10.15+ (Catalina or newer)
- **Zsh** (default on macOS 10.15+)
- **Git** (comes with macOS Command Line Tools)
- **Homebrew** (recommended for additional tools)

### Recommended Tools
These tools enhance the experience but aren't required:
```bash
brew install eza           # Modern ls replacement
brew install zed           # Zed editor
brew install pyenv         # Python version management
brew install nvm           # Node version management (lazy-loaded)
```

## 🏗️ What Gets Installed

### Core Symlinks
- `~/.zshrc` → `~/Developer/dotfiles/shell/.zshrc`
- `~/.config/zed/*` → `~/Developer/dotfiles/zed/*`

### Backup System
Before making changes, the installer:
- ✅ Creates timestamped backups of existing files
- ✅ Safely removes old symlinks
- ✅ Preserves your original configurations

## 📂 Repository Structure

```
dotfiles/
├── 🐚 shell/                    # Modular ZSH configuration
│   ├── .zshrc                   # Main ZSH config (loads modules)
│   └── modules/                 # Modular configuration
│       ├── aliases.zsh          # Command aliases
│       ├── core.zsh             # Essential settings
│       ├── functions.zsh        # Custom functions
│       ├── performance.zsh      # Speed optimizations
│       ├── prompt.zsh           # Prompt configuration
│       └── tools.zsh            # External tool integration
├── ✏️ zed/                       # Zed editor configuration
│   ├── settings.json            # Editor preferences
│   ├── keymap.json             # Custom keybindings
│   └── tasks.json              # Development tasks
├── 📋 docs/                     # Documentation
│   ├── SECRETS.md              # Secret management guide
│   └── SHELL_VALIDATION_REPORT.md # Performance analysis
├── 🔧 install.sh                # Smart installation script
├── 📄 LICENSE                   # MIT License
├── 🤝 CONTRIBUTING.md           # Contribution guidelines
├── 🔒 SECURITY.md               # Security policy
└── 📘 WARP.md                   # AI assistant guidance
```

## ✨ Key Features

### 🚀 Performance-Optimized Shell
- **Lazy loading** for NVM and heavy tools
- **Cached completions** rebuilt only when needed
- **Fast startup** with disabled expensive Oh-My-Zsh features
- **Modular design** for easy customization

### 🎨 Enhanced Developer Experience
- **Modern file listings** with `eza` (colorized with Git status and icons)
- **Smart aliases** for Git, Docker, and common tasks
- **Project navigation** with `work <project>` function
- **Custom prompt** with Git integration

### 🔐 Secure Secret Management
- **Git-ignored** secret files (`.env.secrets`, `.zshrc.local`, `.zshrc.work`)
- **Convenience symlinks** for easy editing
- **Best practices** documented in `docs/SECRETS.md`
- **No secrets in version control** - ever!

### 🎯 Zed Editor Integration
- **Performance-focused** settings (manual save/format)
- **TypeScript/Deno** LSP configuration
- **Project-aware** session restoration
- **Comfortable spacing** and modern UI

## 🛠️ Customization

### Adding Personal Settings
Create machine-specific configs that won't be tracked:

```bash
# Personal settings (gitignored)
touch ~/.zshrc.local
touch ~/.zshrc.work
touch ~/.env.secrets

# Edit through convenient symlinks
zed env.secrets    # → ~/.env.secrets
zed zshrc.local    # → ~/.zshrc.local
zed zshrc.work     # → ~/.zshrc.work
```

### Shell Module System
The ZSH configuration is modular. Edit individual modules in `shell/modules/`:

- **aliases.zsh** - Add your custom aliases
- **functions.zsh** - Define shell functions
- **tools.zsh** - Configure external tools
- **prompt.zsh** - Customize your prompt

### Manual Installation
For more control over the installation:

```bash
# Shell configuration only
ln -sf ~/Developer/dotfiles/shell/.zshrc ~/.zshrc

# Zed editor configuration only
mkdir -p ~/.config/zed
ln -sf ~/Developer/dotfiles/zed/* ~/.config/zed/
```

## 🔄 Maintenance

### Updating
```bash
cd ~/Developer/dotfiles
git pull origin main
./install.sh  # Refresh symlinks if needed
source ~/.zshrc  # Or restart terminal
```

### Uninstalling
```bash
# Remove symlinks and restore backups
rm ~/.zshrc ~/.config/zed/{settings,keymap,tasks}.json

# Find and restore your backups
ls -la ~/*.backup.*
ls -la ~/.config/zed/*.backup.*
```

### Health Check
```bash
# Verify symlinks are working
ls -la ~/.zshrc ~/.config/zed/

# Test shell configuration
zsh -c "source ~/.zshrc && echo 'Shell config OK'"

# Check for broken symlinks
find ~ -type l ! -exec test -e {} \; -print 2>/dev/null | grep dotfiles
```

## 🎨 Shell Aliases & Functions

### File Operations
```bash
ls          # eza with icons and Git status
ll          # Long format listing
la          # Show hidden files
lat         # Tree view
```

### Development
```bash
work <name> # Navigate to project in Developer/ or Repos/
commit "msg" # Quick git commit
test        # Smart test runner (detects project type)
reload      # Reload shell configuration
```

### System
```bash
monitor     # macOS system monitoring
cleanup     # Clean system caches and logs
path        # Pretty print PATH variable
```

## 🔧 Troubleshooting

### Common Issues

**Shell loads slowly:**
- Check if NVM is installed and remove if unused
- Review modules in `shell/modules/` for performance issues

**Symlinks broken after moving dotfiles:**
```bash
cd ~/Developer/dotfiles
./install.sh  # Recreates symlinks
```

**Zed configuration not loading:**
```bash
# Check symlinks
ls -la ~/.config/zed/
# Recreate if needed
./install.sh
```

**Secrets not loading:**
```bash
# Check file permissions
ls -la ~/.env.secrets ~/.zshrc.local
# Should be 600 (readable only by you)
chmod 600 ~/.env.secrets ~/.zshrc.local
```

### Getting Help

- 📖 Check [WARP.md](WARP.md) for detailed guidance
- 🔐 Review [docs/SECRETS.md](docs/SECRETS.md) for secret management
- 🐛 [Open an issue](https://github.com/szymdzum/dotfiles/issues) for bugs
- 💡 [Start a discussion](https://github.com/szymdzum/dotfiles/discussions) for questions

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

Areas where help is especially appreciated:
- 🐧 Linux compatibility
- ⚡ Performance improvements
- 📚 Documentation enhancements
- 🧪 Testing infrastructure

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/) community for shell inspiration
- [Zed](https://zed.dev/) team for an excellent editor
- [eza](https://github.com/eza-community/eza) for modern file listings
- The dotfiles community for sharing knowledge and best practices

---

**Made with ❤️ for productive development environments**
