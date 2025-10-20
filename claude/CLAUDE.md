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

### Searching (Always Use Bash + rg)
```bash
rg <pattern>                    # Smart search
rg <pattern> --type js          # Search only JS files
rg <pattern> -A 3 -B 3          # With context lines
rg <pattern> -l                 # List matching files only
rg <pattern> -c                 # Count matches per file
```

**IMPORTANT: Always prefer Bash + rg over Claude's built-in Grep tool**

**Why:**
- Uses system ripgrep 15.0.0 (newer than bundled 14.1.1)
- Respects custom `RIPGREP_CONFIG_PATH` configuration
- Consistent behavior with terminal usage
- Full control over exclusions and search behavior

**Optimizations (auto-applied via config):**
- Auto-excludes: `node_modules`, `.git`, `dist`, `build`, etc.
- Searches hidden files
- Smart case sensitivity
- Custom file types: `.astro`, `.vue`, `.svelte`, `.mdx`, etc.
- Color-coded output optimized for dark terminals

**Settings:**
- `USE_BUILTIN_RIPGREP: "0"` in `~/.claude/settings.json`
- Config file: `~/Developer/dotfiles/shell/ripgrep/ripgreprc`

**Only use Grep tool when:** You specifically need structured JSON output for programmatic processing.

### JSON Processing (jq Best Practices)
```bash
# Always use these flags for consistency
jq -C .                         # Colorized output
jq -S .                         # Sort keys (predictable)
jq -r .                         # Raw output (no quotes)
jq -c .                         # Compact output (one line)

# Common patterns
jq 'keys'                       # List all keys
jq '.[] | select(.key == "value")'  # Filter objects
jq -r '.field'                  # Extract field without quotes
jq '. + {new: "value"}'         # Add field
```

**Why:** Consistent jq formatting makes JSON parsing more reliable for agents.

### GitHub CLI (gh aliases)
```bash
# Pull Requests
gh prs              # List PRs (compact, tab-separated)
gh prv [number]     # View PR details (compact format)
gh myprs            # List my PRs only
gh checks [number]  # Show PR checks status
gh co [number]      # Checkout PR locally

# Issues
gh issues           # List issues (compact, tab-separated)
gh myissues         # List my issues only
```

**Why:** Custom aliases use `--json` and `--template` to provide structured, parseable output instead of formatted tables.

### GitLab CLI (glab aliases)
```bash
# Merge Requests
glab mrs            # List MRs (20 per page)
glab mrv [number]   # View MR details
glab mymrs          # List my MRs only
glab co [number]    # Checkout MR locally

# Issues
glab issues         # List issues (20 per page)
glab myissues       # List my issues only

# Pipelines
glab pipes          # View pipeline status
glab ci             # Alias for pipeline ci
```

**Why:** Consistent pagination (20 items) and common filters reduce API calls and provide predictable output.

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

**Search Operations:**
- ✅ Use `rg` via Bash tool (respects custom config)
- ❌ Avoid Claude's Grep tool (bypasses custom settings)
- ✅ Example: `rg "pattern" --type ts -A 3` for TypeScript searches

**JSON Operations:**
- ✅ Use `jq -C .` for colorized JSON output
- ✅ Use `jq -S .` for sorted keys (predictable parsing)
- ✅ Use `jq -r '.field'` for raw output without quotes
- ✅ Prefer `jq` over manual JSON parsing

**Git Operations:**
- ✅ Check identity with `git config user.email` in work repos
- ✅ Use `git dirty` to quickly check repo state
- ✅ Use `git changed HEAD~3` to see what changed in last 3 commits

**GitHub/GitLab Operations:**
- ✅ Use `gh prs` / `glab mrs` for compact PR/MR lists
- ✅ Use `gh myissues` / `glab myissues` to filter by assignee
- ✅ Use `gh checks` to verify CI status before merging
- ✅ GitHub aliases provide tab-separated output for easy parsing

## Tool Locations

All optimized configurations are in `~/Developer/dotfiles/`:
- **Git:** `git/gitconfig`, `git/gitconfig-work`
- **Shell:** `shell/.zshrc` and `shell/modules/`
  - **Bat:** `shell/bat/config`
  - **Ripgrep:** `shell/ripgrep/ripgreprc`
- **GitHub CLI:** `~/.config/gh/config.yml` (aliases stored here)
- **GitLab CLI:** `~/.config/glab-cli/config.yml` (aliases stored here)

## Quick Reference

**Installation:**
```bash
cd ~/Developer/dotfiles
./install.sh  # Creates all symlinks
```

**See Also:**
- Project-specific instructions: `./CLAUDE.md` (when available)
- Dotfiles docs: `~/Developer/dotfiles/docs/`
