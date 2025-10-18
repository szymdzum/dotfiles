# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Agent-Optimized Tools

**IMPORTANT:** This dotfiles repo includes optimized configurations for AI agent workflows. Use these tools and shortcuts for efficient operations:

### Git Aliases (Always Available)
```bash
git st              # Short status with branch info
git lg              # Pretty log graph (last 20 commits)
git lga             # Pretty log graph (all branches)
git changed [ref]   # Show changed files since ref
git staged          # List staged files
git unstaged        # List unstaged files
git dirty           # Check if repo is clean or dirty
git last            # Show last commit with stats
```

### File Reading (Use bat instead of cat)
```bash
bat <file>          # Syntax-highlighted file reading
                    # - No pagination (optimized for agents)
                    # - Line numbers enabled
                    # - Better file type detection
```

### Search (ripgrep already optimized)
```bash
rg <pattern>        # Smart search with optimized settings
                    # - Excludes: node_modules, .git, dist, build
                    # - Searches hidden files
                    # - Smart case sensitivity
                    # - Custom file types (astro, vue, svelte, etc.)
```

### GitHub CLI (gh aliases)
```bash
gh prs              # List PRs (compact, tab-separated)
gh prv [number]     # View PR details (compact format)
gh myprs            # List my PRs only
gh myissues         # List my issues only
gh checks [number]  # Show PR checks status
gh co [number]      # Checkout PR locally
```

### GitLab CLI (glab aliases)
```bash
glab mrs            # List MRs (20 per page)
glab mrv [number]   # View MR details
glab mymrs          # List my MRs only
glab myissues       # List my issues only
glab pipes          # View pipeline status
glab co [number]    # Checkout MR locally
```

### Git Identity (Auto-Switching)
- **Personal (GitHub):** Used in `~/Developer/dotfiles` and most repos
- **Work (GitLab):** Used in `~/Developer/kf-ng-web` and `~/Repos/*`
- Identity switches automatically based on repo location/remote

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
