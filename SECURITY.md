# Security Policy

## 🔒 Supported Versions

This dotfiles repository is actively maintained. Security updates are applied to the latest version on the `main` branch.

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |

## 🐛 Reporting a Vulnerability

If you discover a security vulnerability in these dotfiles, please help us maintain security by reporting it responsibly.

### How to Report

**Please do NOT create a public GitHub issue for security vulnerabilities.**

Instead, please:

1. **Email**: Send details to [szymon@kumak.dev](mailto:szymon@kumak.dev)
2. **Subject**: Include "SECURITY:" prefix in the subject line
3. **Details**: Provide as much information as possible:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- **Response Time**: You can expect an initial response within 48 hours
- **Updates**: Regular updates on the progress of the fix
- **Credit**: We'll acknowledge your contribution (unless you prefer to remain anonymous)
- **Timeline**: Security fixes are prioritized and typically resolved within 7-14 days

## 🔐 Security Considerations

### What These Dotfiles Handle

This repository contains:
- Shell configuration files
- Editor settings
- System aliases and functions
- Installation and setup scripts

### Sensitive Data Protection

**✅ What we do:**
- Gitignore sensitive files (`.env.secrets`, `.zshrc.local`, `.zshrc.work`)
- Provide secure patterns for secret management
- Use symlinks to keep secrets outside version control
- Document security best practices in `docs/SECRETS.md`

**❌ What we don't store:**
- API keys or access tokens
- Passwords or credentials
- Personal information
- Private configuration values

### Security Best Practices

When using these dotfiles:

1. **Review before installation**: Always review shell scripts before running them
2. **Keep secrets separate**: Use the provided secret management patterns
3. **Regular audits**: Periodically check for accidentally committed secrets
4. **File permissions**: Ensure secret files have restricted permissions (`chmod 600`)

### Installation Security

The installation script:
- Creates backups before making changes
- Uses safe symlink creation methods
- Validates paths and permissions
- Provides rollback capabilities

## 🛡️ Common Security Issues

### Secret Leakage Prevention

```bash
# ✅ Good: Use separate secret files
# ~/.env.secrets (gitignored)
export API_KEY="your-secret-key"

# ❌ Bad: Don't put secrets in tracked files
# .zshrc (tracked in git)
export API_KEY="your-secret-key"  # This would be committed!
```

### Script Execution

```bash
# ✅ Good: Review and understand scripts
curl -fsSL https://raw.githubusercontent.com/user/repo/main/install.sh | less
./install.sh

# ❌ Risky: Blindly executing remote scripts
curl -fsSL https://raw.githubusercontent.com/user/repo/main/install.sh | bash
```

## 📋 Security Checklist

Before using these dotfiles:

- [ ] Review the installation script (`install.sh`)
- [ ] Check what files will be modified
- [ ] Ensure you have backups of existing configurations
- [ ] Understand what permissions are being set
- [ ] Review the secret management documentation

## 🚨 Incident Response

If you believe your system has been compromised through the use of these dotfiles:

1. **Immediate**: Disconnect from the network if actively being attacked
2. **Assessment**: Determine the scope of the compromise
3. **Containment**: Remove or quarantine affected files
4. **Recovery**: Restore from known good backups
5. **Lessons**: Document what happened and how to prevent it

## 📚 Additional Resources

- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [OWASP Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/)
- [Shell Script Security](https://github.com/anordal/shellharden/blob/master/how_to_do_things_safely_in_bash.md)

---

Thank you for helping keep this project secure! 🛡️