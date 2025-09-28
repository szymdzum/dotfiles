# Secret Management Guide

This guide explains how to securely manage secrets in your dotfiles without exposing them in version control.

## 🔒 Secret Management Strategy

### 1. Environment Files (Recommended)
Store secrets in environment files that are loaded but not tracked:

```bash
# ~/.env.secrets (automatically loaded by .zshrc)
export OPENAI_API_KEY="sk-..."
export GITHUB_TOKEN="ghp_..."
export AWS_ACCESS_KEY_ID="AKIA..."
export CLAUDE_API_KEY="sk-..."
```

### 2. Machine-Specific Configs
Use local config files for machine-specific settings:

```bash
# ~/.zshrc.local (for personal machine)
export PERSONAL_PROJECT_DIR="~/MyProjects"
export DEV_DATABASE_URL="localhost:5432"

# ~/.zshrc.work (for work machine)  
export WORK_PROJECT_DIR="~/WorkProjects"
export CORPORATE_PROXY="proxy.company.com:8080"
```

### 3. macOS Keychain Integration
For maximum security, use macOS Keychain:

```bash
# Store secret
security add-generic-password -a "$(whoami)" -s "openai_api_key" -w

# Retrieve in shell function
get_openai_key() {
  security find-generic-password -a "$(whoami)" -s "openai_api_key" -w 2>/dev/null
}
```

## 📁 Directory Structure

```
~/
├── .env.secrets          # Main secrets file (not tracked)
├── .zshrc.local          # Machine-specific config (not tracked)  
├── .zshrc.work          # Work-specific config (not tracked)
└── Developer/
    └── dotfiles/
        ├── shell/.zshrc  # Loads secrets if they exist
        └── .gitignore    # Excludes all secret patterns
```

## 🛠️ Implementation

### Current Setup (Already Working)
Your `.zshrc` already includes:
```bash
# Load private environment variables (API keys, secrets)
[ -f ~/.env.secrets ] && source ~/.env.secrets

# Load local machine-specific configurations  
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Load work-specific configurations
[ -f ~/.zshrc.work ] && source ~/.zshrc.work
```

### Creating Secret Files
```bash
# Create your secrets file
touch ~/.env.secrets
chmod 600 ~/.env.secrets  # Restrict permissions

# Edit with your preferred editor (direct or via symlink)
zed ~/.env.secrets
# OR use the convenient symlink in your dotfiles directory
zed ~/Developer/dotfiles/env.secrets
```

### Convenience Symlinks
Your dotfiles include handy symlinks for easy editing:
```bash
# From your dotfiles directory, you can edit:
zed env.secrets    # -> ~/.env.secrets
zed zshrc.local    # -> ~/.zshrc.local  
zed zshrc.work     # -> ~/.zshrc.work
```

These symlinks are:
- ✅ **Git-ignored** (never tracked)
- ✅ **Automatically created** by install.sh
- ✅ **Convenient** for editing from your dotfiles directory

### Example Secret File Structure
```bash
# ~/.env.secrets
# API Keys
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GITHUB_TOKEN="ghp_..."

# Cloud Providers
export AWS_ACCESS_KEY_ID="AKIA..."
export AWS_SECRET_ACCESS_KEY="..."
export GOOGLE_APPLICATION_CREDENTIALS="path/to/service-account.json"

# Development
export DATABASE_URL="postgresql://user:pass@localhost/db"
export REDIS_URL="redis://localhost:6379"

# Other Tools
export HOMEBREW_GITHUB_API_TOKEN="$GITHUB_TOKEN"
```

## 🔍 Security Best Practices

### 1. File Permissions
```bash
chmod 600 ~/.env.secrets      # Owner read/write only
chmod 600 ~/.zshrc.local      # Owner read/write only
chmod 600 ~/.zshrc.work       # Owner read/write only
```

### 2. Regular Audits
```bash
# Check for accidentally committed secrets
git log --all -S "sk-" -S "ghp_" -S "AKIA" --oneline

# Scan current files for potential secrets
grep -r "sk-\|ghp_\|AKIA\|Bearer" . --exclude-dir=.git
```

### 3. Git Hooks (Optional)
Create a pre-commit hook to prevent accidental commits:
```bash
#!/bin/sh
# .git/hooks/pre-commit
if git diff --cached --name-only | xargs grep -l "sk-\|ghp_\|AKIA" 2>/dev/null; then
  echo "❌ Potential secrets detected in staged files!"
  exit 1
fi
```

## 🚀 Advanced: Secret Management Tools

### 1. Age Encryption (for shared configs)
```bash
# Install age
brew install age

# Encrypt secrets
age -e -o secrets.age ~/.env.secrets

# Decrypt (when needed)
age -d secrets.age > ~/.env.secrets
```

### 2. SOPS (Mozilla's Secret OPerationS)
```bash
# Install sops
brew install sops

# Create encrypted file
sops ~/.env.secrets.enc
```

### 3. Bitwarden CLI (for team secrets)
```bash
# Install Bitwarden CLI
brew install bitwarden-cli

# Login and sync secrets
bw login && bw sync
```

## ✅ Verification Checklist

- [ ] `.env.secrets` exists and has correct permissions (600)
- [ ] Secrets are NOT in any tracked files
- [ ] `.gitignore` covers all secret patterns
- [ ] Machine-specific configs use `.local` or `.work` suffixes
- [ ] Regular audits performed for leaked secrets
- [ ] Backup strategy exists for critical secrets

## 🆘 Emergency: Secret Leaked

If you accidentally commit a secret:

1. **Immediately rotate/revoke** the compromised secret
2. **Remove from Git history**:
   ```bash
   git filter-branch --force --index-filter \
   'git rm --cached --ignore-unmatch path/to/secret/file' \
   --prune-empty --tag-name-filter cat -- --all
   ```
3. **Force push** (if safe): `git push --force`
4. **Update** secret in secure location