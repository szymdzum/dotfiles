# Agent-Optimized Tool Configurations

This document outlines potential optimizations for development tools to improve Claude Code's (and other AI agents') workflow efficiency.

## Context: How Claude Code Executes Commands

**What Claude Code CAN use:**
- ✅ Direct commands (`git`, `rg`, `bat`, `jq`, etc.)
- ✅ Tool configuration files (`.gitconfig`, `ripgreprc`, etc.)
- ✅ Environment variables
- ✅ Scripts and executables in `$PATH`

**What Claude Code CANNOT use (without explicit sourcing):**
- ❌ Shell aliases
- ❌ Shell functions
- ❌ Oh-My-Zsh plugins

**Key Insight:** Optimize tool configs, not shell configs.

---

## Current Optimizations

### ✅ Ripgrep (`ripgrep/ripgreprc`)

**Status:** Already optimized!

**Key features:**
- No max-columns limit (AI needs full context)
- Smart case-insensitive search
- Custom file types for modern web dev
- Exclusions for build artifacts
- Multi-threading enabled
- No sorting (preserves parallelism)

**Impact:** High - Agents use search constantly

---

## Recommended Optimizations

### 1. Git Configuration (HIGH IMPACT)

**File:** `git/gitconfig`

**Why:** Agents interact with git constantly. Optimized output = fewer tokens, faster parsing.

**Proposed settings:**

```gitconfig
[core]
    # Don't paginate short output (agents don't need pagination)
    pager = less -FRX

[log]
    # Consistent, parseable format
    decorate = short

[diff]
    # Remove a/ b/ prefixes (cleaner output)
    noprefix = true
    # Better diff algorithm (more readable)
    algorithm = histogram
    # Balanced context (not too much, not too little)
    context = 3

[status]
    # Show branch and tracking info
    showBranch = true

[alias]
    # Short, structured outputs
    st = status --short --branch
    lg = log --oneline --graph --decorate --max-count=20
    changed = diff --name-status
    files = ls-files
    staged = diff --cached --name-only
    unstaged = diff --name-only
```

**Benefits:**
- Consistent, parseable formats
- Reduced token usage
- Faster git operations
- No interactive pagination

---

### 2. Bat Configuration (MEDIUM IMPACT)

**File:** `bat/config`

**Why:** Agents read files frequently. Syntax highlighting adds context without extra tool calls.

**Proposed settings:**

```
# Theme optimized for AI context
--theme="base16"

# Show line numbers and grid
--style="numbers,grid"

# CRITICAL: No pagination for agents
--paging=never

# Don't wrap lines (preserve structure)
--wrap=never

# Tab width
--tabs=2

# File type mappings
--map-syntax="*.conf:INI"
--map-syntax=".gitignore:Git Ignore"
--map-syntax="*.env:Bash"
--map-syntax="*.prisma:Rust"
--map-syntax="Dockerfile*:Dockerfile"
```

**Benefits:**
- Syntax highlighting for context
- No pagination delays
- Consistent formatting
- Better file type detection

---

### 3. Enhanced Tool Documentation (LOW EFFORT, HIGH VALUE)

**File:** `docs/claude/tool-configs.md`

Create documentation explaining:
- Which tool configs exist
- Why each optimization matters
- How to test configurations
- Examples of agent-friendly commands

**Benefits:**
- Agents can reference optimizations
- Human developers understand the setup
- Easy to maintain and update

---

## Not Recommended

### ❌ Shell Aliases/Functions

**Why not:** Claude Code doesn't load `.zshrc` by default. While it's possible to source it explicitly with `zsh -c "source ~/.zshrc && command"`, this:
- Adds complexity
- Slows down execution
- Isn't portable across shells
- Can cause unexpected behavior

**Alternative:** Use direct commands and tool configs instead.

### ❌ FZF Configuration

**Why not:** FZF requires interactive sessions. While useful for humans, agents can use direct search commands more efficiently (ripgrep, fd, etc.).

---

## Implementation Priority

1. **High Priority:** Git configuration (agents use git constantly)
2. **Medium Priority:** Bat configuration (improves file reading)
3. **Low Priority:** Documentation (nice to have)

---

## Testing Optimizations

Test if agents can use your configurations:

```bash
# Test git config
git config --get core.pager

# Test bat config
bat --config-file

# Test ripgrep config
echo $RIPGREP_CONFIG_PATH

# Test if env vars are available
env | grep RIPGREP
```

---

## Future Considerations

**Potential additions:**
- `.editorconfig` - Consistent formatting across tools
- `.prettierrc` - Code formatting standards
- `tsconfig.json` template - TypeScript optimizations
- Language-specific linter configs

**Principle:** Optimize for **structured output**, **consistent formats**, and **minimal noise**.
