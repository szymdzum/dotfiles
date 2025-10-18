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
├── 📦 install.sh      # Installation script
├── 🔧 setup.sh        # Legacy setup script
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
