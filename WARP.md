# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Essential Commands

### Installation & Setup
```bash
# Fresh installation (creates symlinks to ~/.zshrc, ~/.config/zed/*)
./install.sh

# Manual shell configuration only
ln -sf ~/Developer/dotfiles/shell/.zshrc ~/.zshrc
ln -sf ~/Developer/dotfiles/zed/* ~/.config/zed/
# Manual Zed editor configuration  
mkdir -p ~/.config/zed
ln -sf ~/Developer/.dotfiles/zed/* ~/.config/zed/

# Reload shell after changes
source ~/.zshrc
```

### Updates & Maintenance
```bash
# Pull latest changes and re-create symlinks
git pull && ./install.sh

# Check what files are currently symlinked
ls -la ~ | grep "dotfiles"
ls -la ~/.config/zed/ | grep "dotfiles"

# Test shell configuration without applying
zsh -n shell/.zshrc  # Syntax check
```

### Backup & Recovery
```bash
# Restore from automatic backup (created during install)
ls -la ~/*.backup.*  # Find backup files
mv ~/.zshrc.backup.YYYYMMDD_HHMMSS ~/.zshrc

# Create manual backup before making changes
cp ~/.zshrc ~/.zshrc.manual.$(date +%Y%m%d_%H%M%S)
```

### Development & Testing
```bash
# Test new shell functions/aliases in isolated session
zsh -c "source shell/.zshrc && your_command_here"

# Validate Zed configuration
zed --validate zed/settings.json

# Check for broken symlinks
find ~ -type l ! -exec test -e {} \; -print 2>/dev/null | grep dotfiles
```

## Architecture Overview

### Symlink-Based Configuration System
This dotfiles setup uses symbolic links to keep configurations in version control while placing them where applications expect them:

```
~/.zshrc -> ~/Developer/dotfiles/shell/.zshrc
~/.config/zed/* -> ~/Developer/dotfiles/zed/*
```

### Directory Structure
```
dotfiles/
├── shell/              # Shell configurations
│   └── .zshrc         # Performance-optimized zsh config
├── zed/               # Zed editor configurations
│   ├── settings.json  # Zed editor settings
│   ├── keymap.json    # Zed editor keybindings
│   └── tasks.json     # Zed editor tasks
├── git/               # Git configuration (placeholder)
├── install.sh         # Modern installation script with backups
├── setup.sh           # Legacy setup script  
├── WARP.md            # This file
└── README.md          # User documentation
```

### Installation Flow
1. **install.sh** creates automatic timestamped backups of existing configs
2. Removes old symlinks, preserves real files as `.backup.TIMESTAMP`
3. Creates new symlinks from dotfiles to home directory locations
4. Handles both shell and editor configurations in one run

## Key Features

### Shell Performance Optimizations
- **Lazy loading**: NVM and heavy tools loaded only when needed
- **Cached completions**: Rebuilds only once per day
- **Fast startup**: Disabled expensive Oh-My-Zsh features
- **Modern tools**: Uses `eza` for colorized `ls` with Git status and icons

### Development Tool Integration
- **Python**: PyEnv integration for version management
- **Node**: NVM with lazy loading for faster shell startup
- **Package managers**: PNPM, Yarn support
- **Editor**: Zed-first workflow (per user preference)

### Zed Editor Configuration
- **Performance-focused**: Manual save/format workflow, no auto-save
- **TypeScript/Deno**: Configured for Deno LSP with inlay hints
- **UI**: Comfortable spacing, file icons, Git status integration
- **Project-aware**: Restoration of last session, auto-reveal entries

### Custom Functions & Aliases
- **Smart navigation**: `work <project>` searches Developer/ and Repos/ directories
- **Modern file operations**: `eza`-based `ls` commands with icons and Git status  
- **Development shortcuts**: `project <name>`, `commit <message>`, `test` (detects project type)
- **System monitoring**: `monitor` command for macOS system status

## Development Workflow

### Adding New Configurations
1. Add shell configs to `shell/` subdirectory, Zed configs to `zed/` subdirectory
2. Update `install.sh` to handle new symlinks if needed
3. Test installation in clean environment or with manual symlink
4. Update README.md and this WARP.md with new features

### Making Shell Changes
1. Edit `shell/.zshrc` directly
2. Test with `zsh -c "source shell/.zshrc && command"`
3. Apply with `source ~/.zshrc` or `reload` alias
4. Commit changes with descriptive message about shell improvement

### Modifying Zed Configuration
1. Edit files in `zed/` directory (settings.json, keymap.json, tasks.json)
2. Changes apply immediately due to symlinks (Zed auto-reloads)
3. Test language server configurations and shortcuts
4. Commit editor workflow improvements

### Syncing Across Machines
1. Clone repository to `~/Developer/dotfiles` on new machine
2. Run `./install.sh` for automatic setup with backups
3. Install required tools: `eza`, `pyenv`, `nvm` if missing
4. Machine-specific configs go in `~/.zshrc.local` (not tracked)

### Handling Secrets
- **See SECRETS.md** for comprehensive secret management guide
- **Convenience symlinks**: `env.secrets`, `zshrc.local`, `zshrc.work` for easy editing
- Add sensitive environment variables to `~/.env.secrets` (loaded by .zshrc)
- Machine-specific API keys go in `~/.zshrc.work` or `~/.zshrc.local`
- All secret files are git-ignored and accessible via symlinks in dotfiles directory

### Testing Changes
```bash
# Syntax check shell config
zsh -n shell/.zshrc

# Test specific function in isolated session  
zsh -c "source shell/.zshrc && work blog"

# Validate JSON configurations
python3 -m json.tool zed/settings.json

# Check for broken symlinks after install
./install.sh && find ~ -path "*/dotfiles/*" -type l ! -exec test -e {} \; -print
```