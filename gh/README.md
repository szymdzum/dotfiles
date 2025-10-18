# GitHub CLI Configuration

This directory contains GitHub CLI settings and secrets.

## Files

- `config.yml` - Main configuration with aliases and preferences (**VERSION CONTROLLED**)
- `hosts.yml` - Authentication tokens (**IN DOTFILES, NOT VERSION CONTROLLED**)

## Setup

The `install.sh` script will:
1. Symlink `config.yml` → `~/.config/gh/config.yml`
2. Symlink `hosts.yml` → `~/.config/gh/hosts.yml`

Both files are in the dotfiles directory for easy editing!

## Editing Secrets

You can edit the tokens directly from the dotfiles directory:
```bash
zed gh/hosts.yml
# or
zed ~/Developer/dotfiles/gh/hosts.yml
```

The `hosts.yml` file is **git-ignored** so your tokens won't be committed, but they're kept in dotfiles for convenience.
