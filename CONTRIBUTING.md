# Contributing to Dotfiles

Thank you for your interest in contributing to this dotfiles repository! This guide will help you understand how to contribute effectively.

## 🐛 Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates.

**When reporting a bug, please include:**
- Your operating system (macOS version, Linux distribution)
- Shell version (`zsh --version`)
- Steps to reproduce the issue
- Expected vs actual behavior
- Any error messages or output
- Relevant configuration files

## 💡 Suggesting Enhancements

Enhancement suggestions are welcome! Please:
- Check if the enhancement has already been requested
- Provide a clear description of the feature
- Explain why it would be useful
- Include examples of how it would work

## 🔧 Development Guidelines

### Shell Script Standards
- Use `#!/bin/bash` or `#!/usr/bin/env zsh` shebangs
- Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Use meaningful variable names in `UPPER_CASE` for globals
- Quote variables to prevent word splitting: `"$variable"`
- Use `[[ ]]` instead of `[ ]` for conditionals
- Include error handling with `set -e` when appropriate

### Code Style
```bash
# Good
if [[ -f "$HOME/.zshrc" ]]; then
    echo "Found zshrc file"
fi

# Bad
if [ -f $HOME/.zshrc ]
then
echo "Found zshrc file"
fi
```

### Testing
- Test your changes on a clean system when possible
- Ensure scripts work with both interactive and non-interactive shells
- Test symlink creation and removal
- Verify that rollback/backup functionality works

### Documentation
- Update README.md if you add new features
- Document any new configuration options
- Include examples in comments for complex functions
- Update WARP.md if changing project structure

## 📝 Commit Message Conventions

Use clear, descriptive commit messages:

```
feat: add support for Linux package managers
fix: resolve symlink creation on macOS Catalina
docs: update installation instructions
refactor: modularize zsh configuration
style: fix shellcheck warnings in install script
test: add validation for shell functions
```

### Prefixes:
- `feat:` - New features
- `fix:` - Bug fixes  
- `docs:` - Documentation updates
- `style:` - Code style changes
- `refactor:` - Code refactoring
- `test:` - Testing additions/updates
- `chore:` - Maintenance tasks

## 🔄 Pull Request Process

1. **Fork** the repository and create your feature branch from `main`
2. **Test** your changes thoroughly
3. **Lint** shell scripts: `shellcheck *.sh`
4. **Update** documentation as needed
5. **Write** a clear pull request description explaining:
   - What changes you made
   - Why you made them
   - How to test them

### Pull Request Template
```markdown
## Changes
- Brief description of changes

## Testing
- [ ] Tested on macOS
- [ ] Tested on Linux (if applicable)
- [ ] Shell scripts pass shellcheck
- [ ] Documentation updated

## Screenshots (if UI changes)
[Include relevant screenshots]
```

## 🏗️ Development Setup

```bash
# Clone your fork
git clone https://github.com/your-username/dotfiles.git
cd dotfiles

# Create a feature branch
git checkout -b feature/your-feature-name

# Test your changes
./install.sh --dry-run  # If available
shellcheck *.sh

# Make your changes and commit
git add .
git commit -m "feat: description of your changes"

# Push and create PR
git push origin feature/your-feature-name
```

## 🎯 Areas for Contribution

We especially welcome contributions in these areas:
- **Cross-platform compatibility** (Linux distributions)
- **Performance optimizations** for shell startup time
- **New useful aliases and functions**
- **Better error handling and user feedback**
- **Documentation improvements**
- **Testing infrastructure**

## 📚 Resources

- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
- [Zsh Manual](https://zsh.sourceforge.io/Doc/Release/zsh_toc.html)
- [ShellCheck](https://www.shellcheck.net/) - Shell script linter
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

## ❓ Questions

If you have questions about contributing:
- Open an issue with the `question` label
- Check the existing documentation in README.md and WARP.md
- Review closed issues for similar questions

## 🙏 Recognition

All contributors will be acknowledged in the project. Thank you for helping improve these dotfiles!