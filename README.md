# 🏠 Dotfiles

My personal development environment configuration files.

## 📂 Structure

```
dotfiles/
├── 🐚 shell/          # Shell configuration
│   └── .zshrc         # Zsh configuration with modern aliases
├── ✏️  zed/            # Zed editor configuration
│   ├── settings.json  # Zed editor settings
│   ├── keymap.json    # Zed editor keybindings
│   └── tasks.json     # Zed editor tasks
├── 🗃️  git/            # Git configuration (future)
├── 📦 install.sh      # Installation script
├── 📘 WARP.md         # AI assistant guidance
├── 🔒 SECRETS.md      # Secret management guide
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

### Git Configuration
- 🔧 **Standard Git settings** with helpful aliases
- 🔐 **Pre-commit hook** for secret scanning (optional)
- 📝 **Machine-specific overrides** via ~/.gitconfig.local

## 🔒 Security

Protect your secrets with the optional pre-commit hook:

```bash
# Install the pre-commit hook to scan for secrets
cp git/hooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

This hook will:
- ✅ Scan for API keys, tokens, and passwords before commits
- ✅ Block commits containing potential secrets
- ✅ Provide clear guidance on proper secret management

See [SECRETS.md](docs/SECRETS.md) for detailed secret management practices.

## 🔄 Updating

```bash
cd ~/Developer/.dotfiles
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
