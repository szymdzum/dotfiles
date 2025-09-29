# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Essential Commands

### Installation & Setup
```bash
# Fresh installation (creates symlinks to ~/.zshrc, ~/.config/zed/*)
./install.sh

# Test shell configuration without applying changes
zsh -n shell/.zshrc

# Reload shell configuration after changes
source ~/.zshrc
```

### Maintenance & Debugging
```bash
# Update dotfiles and refresh symlinks
git pull && ./install.sh

# Check symlink status
ls -la ~/.zshrc ~/.config/zed/

# Check for broken symlinks
find ~ -type l ! -exec test -e {} \; -print 2>/dev/null | grep dotfiles

# Test shell modules in isolation
zsh -c "source shell/modules/core.zsh && echo 'Core module OK'"
```

### Development Testing
```bash
# Test shell functions/aliases without affecting current session
zsh -c "source shell/.zshrc && your_command_here"

# Validate JSON configurations
python -m json.tool zed/settings.json > /dev/null && echo "Valid JSON"
python -m json.tool zed/tasks.json > /dev/null && echo "Valid JSON"
```

## Architecture Overview

### Symlink-Based Configuration System
This dotfiles repository uses symbolic links to keep configurations in version control while placing them where applications expect them:

- `~/.zshrc` → `~/Developer/dotfiles/shell/.zshrc`
- `~/.config/zed/*` → `~/Developer/dotfiles/zed/*`

The system uses Git for configuration history and rollback capability instead of traditional backup files.

### Modular Shell Configuration
The shell configuration is organized in a strict loading order in `shell/.zshrc`:

1. **core.zsh** - Essential settings, PATH, history, environment variables
2. **performance.zsh** - Completion system initialization and caching
3. **prompt.zsh** - Oh-My-Zsh and theme configuration
4. **tools.zsh** - Development tool configurations (NVM, PyEnv, etc.)
5. **aliases.zsh** - All command aliases
6. **functions.zsh** - Custom shell functions

### Secret Management Architecture
- **Git-ignored files**: `.env.secrets`, `.zshrc.local`, `.zshrc.work`
- **Convenience symlinks**: `env.secrets`, `zshrc.local`, `zshrc.work` in repo root
- **Loading order**: Secrets loaded after all modules to allow overrides

## Key Implementation Details

### Performance Optimizations
- **Lazy loading**: NVM and heavy tools only loaded when first used
- **Completion caching**: ZSH completions rebuilt once daily, not on every startup
- **Disabled features**: Oh-My-Zsh auto-updates, magic functions, and file tracking for Git performance

### Development Tool Integration
- **Modern replacements**: Uses `eza` instead of `ls` for enhanced file listings
- **Smart navigation**: `work <project>` function searches both `~/Developer/` and `~/Repos/`
- **Git integration**: Enhanced commit function with branch information
- **Editor preference**: Zed-first workflow with `fz` function for quick file opening

### Zed Editor Configuration
- **Performance-focused**: Manual save/format workflow, disabled auto-save
- **TypeScript/Deno**: Configured for Deno LSP with inlay hints enabled
- **Project settings**: Session restoration, comfortable UI spacing
- **Task integration**: Configured development tasks in `zed/tasks.json`

## Important File Locations

### Shell Modules
- `shell/modules/core.zsh` - Core environment and PATH configuration
- `shell/modules/functions.zsh` - Custom functions like `work`, `commit`, `fz`
- `shell/modules/aliases.zsh` - Enhanced aliases for common commands
- `shell/modules/tools.zsh` - Development tool lazy-loading

### Configuration Files
- `zed/settings.json` - Zed editor preferences and LSP configuration
- `zed/tasks.json` - Development task definitions for Zed
- `zed/keymap.json` - Custom keybindings for Zed editor

### Scripts
- `install.sh` - Main installation script (preferred over setup.sh)
- `setup.sh` - Legacy setup script with backup functionality

## Working with Secret Files

Secret files are git-ignored but accessible via convenience symlinks in the repository root:
- Edit: `zed env.secrets` (maps to `~/.env.secrets`)
- Edit: `zed zshrc.local` (maps to `~/.zshrc.local`)
- Edit: `zed zshrc.work` (maps to `~/.zshrc.work`)

These files are loaded after all modules, allowing environment variable overrides and machine-specific configurations.