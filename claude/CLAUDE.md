# Global Claude Code Configuration

Personal preferences and optimizations for all projects.

## Agent-Optimized Tools

**Always use these optimized tools for better efficiency:**

### Git Commands (Use Aliases)
```bash
# Status and logs
git st              # Short status with branch info
git lg              # Pretty log graph (last 20 commits)
git lga             # Pretty log graph (all branches)
git last            # Show last commit with stats

# File operations
git changed [ref]   # Show changed files since ref
git staged          # List staged files
git unstaged        # List unstaged files
git files           # List all tracked files

# State checks
git dirty           # Check if repo is clean or dirty
git branches        # List branches with tracking info
```

**Why:** Git aliases provide structured, concise output optimized for parsing. Configured in `~/.gitconfig`.

### File Reading (Always Use bat)
```bash
bat <file>          # Instead of cat
bat <file> | head   # With piping
```

**Features:**
- Syntax highlighting (better context)
- Line numbers (for references)
- No pagination (optimized for agents)
- Better file type detection

**Why:** Bat adds syntax highlighting that improves code understanding without extra API calls.

### Searching (Ripgrep is Optimized)
```bash
rg <pattern>                    # Smart search
rg <pattern> --type js          # Search only JS files
rg <pattern> -A 3 -B 3          # With context lines
```

**Optimizations:**
- Auto-excludes: `node_modules`, `.git`, `dist`, `build`, etc.
- Searches hidden files
- Smart case sensitivity
- Custom file types: `.astro`, `.vue`, `.svelte`, `.mdx`, etc.

**Why:** Ripgrep config in `$RIPGREP_CONFIG_PATH` provides sensible defaults for development.

## Development Workflow

### Git Identity
Git automatically switches between identities:
- **Personal (GitHub):** Default for most projects
  - Name: Kumak
  - Email: szymon@kumak.dev
- **Work (GitLab):** Auto-activated for:
  - `~/Developer/kf-ng-web/`
  - `~/Repos/*`
  - Repos with `gitlab.kfplc.com` remotes

### Best Practices

**File Operations:**
- ✅ Use `bat` instead of `cat` for syntax highlighting
- ✅ Use `git st` instead of `git status` for concise output
- ✅ Use `git lg` instead of `git log` for readable history
- ✅ Use `rg` for searching (already optimized)

**Git Operations:**
- ✅ Check identity with `git config user.email` in work repos
- ✅ Use `git dirty` to quickly check repo state
- ✅ Use `git changed HEAD~3` to see what changed in last 3 commits

## Tool Locations

All optimized configurations are in `~/Developer/dotfiles/`:
- **Git:** `git/gitconfig`, `git/gitconfig-work`
- **Bat:** `bat/config`
- **Ripgrep:** `ripgrep/ripgreprc`
- **Shell:** `shell/.zshrc` and `shell/modules/`

## Quick Reference

**Installation:**
```bash
cd ~/Developer/dotfiles
./install.sh  # Creates all symlinks
```

**See Also:**
- Project-specific instructions: `./CLAUDE.md` (when available)
- Dotfiles docs: `~/Developer/dotfiles/docs/`
