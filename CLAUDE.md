# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Essential Commands

### Installation & Setup
```bash
# Fresh installation (creates symlinks and backups)
./install.sh

# Reload shell after changes
source ~/.zshrc

# Test shell configuration without applying
zsh -n shell/.zshrc
```

### Testing & Validation
```bash
# Validate JSON configurations
python3 -m json.tool zed/settings.json
python3 -m json.tool codex/config.toml

# Check for broken symlinks after install
find ~ -path "*/dotfiles/*" -type l ! -exec test -e {} \; -print 2>/dev/null

# Test specific shell function in isolated session
zsh -c "source shell/.zshrc && <command>"
```

### Updates
```bash
# Pull latest and re-create symlinks
git pull && ./install.sh
```

## Architecture Overview

### Symlink-Based Configuration System
This is a dotfiles repository that uses symbolic links to keep configurations in version control while placing them where applications expect:

```
~/.zshrc -> ~/Developer/dotfiles/shell/.zshrc
~/.config/zed/* -> ~/Developer/dotfiles/zed/*
~/.codex/config.toml -> ~/Developer/dotfiles/codex/config.toml
```

**Installation Flow:**
1. `install.sh` creates automatic timestamped backups of existing configs (`.backup.TIMESTAMP`)
2. Removes old symlinks, preserves real files as backups
3. Creates new symlinks from dotfiles to home directory locations
4. Creates convenience symlinks for secret files (git-ignored)

### Modular Shell Configuration
The `.zshrc` uses a modular architecture where configuration is split across focused modules loaded in specific order:

```
shell/
├── .zshrc                    # Main entry point, loads modules
└── modules/
    ├── core.zsh             # Essential settings, PATH, history (loaded first)
    ├── performance.zsh      # Completion caching, optimization
    ├── prompt.zsh           # Oh-My-Zsh, theme, plugins
    ├── tools.zsh            # NVM, PyEnv (lazy-loaded)
    ├── aliases.zsh          # All command aliases
    └── functions.zsh        # Custom shell functions
```

**Loading Order:** core → performance → prompt → tools → aliases → functions → secrets

**Why This Matters:**
- When editing shell config, modify the appropriate module file in `shell/modules/`, NOT `.zshrc` directly
- Module order matters: changing load order can break functionality
- The main `.zshrc` is minimal and just orchestrates module loading

### Secret Management Architecture
Secrets are NEVER committed to git. The system loads optional secret files at shell startup:

```
~/.env.secrets      # API keys, tokens (loaded by .zshrc)
~/.zshrc.local      # Machine-specific configs
~/.zshrc.work       # Work-specific configs
```

**Convenience symlinks** (created by `install.sh`, git-ignored):
```
dotfiles/env.secrets -> ~/.env.secrets
dotfiles/zshrc.local -> ~/.zshrc.local
dotfiles/zshrc.work -> ~/.zshrc.work
```

This allows editing secrets from the dotfiles directory without tracking them in git.

### Editor Configuration

**Zed Editor (`zed/`):**
- `settings.json` - Editor settings (manual save/format workflow, Deno LSP)
- `keymap.json` - Custom keybindings
- `tasks.json` - Development tasks

**Codex (`codex/`):**
- `config.toml` - Codex CLI configuration (workspace write access, model settings)
- `config.local.toml` - Machine-specific settings (symlinked, not tracked)

Changes to these files apply immediately due to symlinks.

## Key Features

### Shell Performance Optimizations
- **Lazy loading:** NVM and PyEnv loaded on first use (not at startup)
- **Cached completions:** Rebuilt once per 24 hours, not every shell startup
- **Disabled:** Oh-My-Zsh auto-update checks, magic functions, git untracked file dirty checks
- **Modern tools:** `eza` for colorized `ls` with Git status and icons

### Development Workflow Patterns

**When modifying shell configuration:**
1. Edit the appropriate module in `shell/modules/`
2. Test with `zsh -c "source shell/.zshrc && <command>"` or `zsh -n shell/.zshrc` for syntax
3. Apply with `source ~/.zshrc`
4. Changes are immediately available (symlinked)

**When modifying editor configs:**
1. Edit files in `zed/` or `codex/` directories
2. Changes apply immediately (editors auto-reload symlinked configs)
3. Validate JSON: `python3 -m json.tool <file>`

**When adding new configurations:**
1. Add to appropriate directory (`shell/`, `zed/`, `codex/`)
2. Update `install.sh` if new symlinks needed
3. Test installation: `./install.sh`
4. Update README.md with new features

### Secret File Editing
Edit secrets easily via convenience symlinks (from dotfiles directory):
```bash
zed env.secrets    # Edit API keys
zed zshrc.local    # Edit machine-specific config
zed zshrc.work     # Edit work-specific config
```

See `docs/SECRETS.md` for comprehensive secret management guide.

## Important Notes

### Git Configuration
- **Main branch:** `main` (no default upstream configured yet)
- **Git-ignored:** All secret files, backups, machine-specific configs, convenience symlinks
- **Modified files (current):** `.gitignore`, `install.sh`, plus untracked `codex/` directory

### Directory Conventions
- `~/Developer/dotfiles` - This repository's expected location
- `~/Developer/` - Personal projects (referenced by shell functions)
- `~/Repos/` - Alternative project location (referenced by shell functions)

### Shell Module Dependencies
- `core.zsh` exports `DEVELOPER_HOME`, `REPOS` used by other modules
- `tools.zsh` provides lazy-loaded `nvm()` and `pyenv()` functions
- `aliases.zsh` depends on `eza` being installed for modern `ls` behavior
- Changes to environment variables in `core.zsh` may affect other modules
