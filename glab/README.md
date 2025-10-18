# GitLab CLI Configuration

This directory contains GitLab CLI settings and secrets.

## Files

- `aliases.yml` - Command aliases (**VERSION CONTROLLED**)
- `config.yml` - Full configuration with settings AND tokens (**IN DOTFILES, NOT VERSION CONTROLLED**)
- `config.template.yml` - Template config without secrets (for reference, **VERSION CONTROLLED**)

## Setup

The `install.sh` script will:
1. Symlink `aliases.yml` → `~/.config/glab-cli/aliases.yml`
2. Symlink `config.yml` → `~/.config/glab-cli/config.yml`

Both files are in the dotfiles directory for easy editing!

## Editing Secrets

You can edit the config with tokens directly from the dotfiles directory:
```bash
zed glab/config.yml
# or
zed ~/Developer/dotfiles/glab/config.yml
```

The `config.yml` file is **git-ignored** so your tokens won't be committed, but it's kept in dotfiles for convenience.

The `config.template.yml` is version controlled and shows the structure without secrets.
