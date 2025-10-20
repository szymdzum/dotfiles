# Claude Code Settings

This repository mirrors the official Claude Code configuration model described in the public documentation, including hierarchical `settings.json` files and environment-variable overrides.citeturn0view0

## Settings Files & Precedence
- Global defaults live in `~/.claude/settings.json`, while project-level overrides belong in `.claude/settings.json` (shared) and `.claude/settings.local.json` (ignored by git).citeturn0view0
- Enterprise administrators can pin policies in `/Library/Application Support/ClaudeCode/managed-settings.json` (macOS), `/etc/claude-code/managed-settings.json` (Linux/WSL), or `C:\ProgramData\ClaudeCode\managed-settings.json` (Windows).citeturn0view0
- Precedence from highest to lowest is: managed policies → CLI flags → project-local settings → shared project settings → user settings.citeturn0view0

## Keys We Use in `claude/settings.json`
- `env`: injects variables into every session; we rely on this to set `USE_BUILTIN_RIPGREP`, `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR`, `BASH_DEFAULT_TIMEOUT_MS`, `DISABLE_TELEMETRY`, and `DISABLE_ERROR_REPORTING`.citeturn0view0
- `statusLine`: executes our `claude/statusline.sh` script so the CLI shows repo-aware context.citeturn0view0
- `alwaysThinkingEnabled`: the current CLI accepts this flag even though it is not documented; keep it `false` to avoid unsolicited background reasoning.

## Environment Variables of Interest
- `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1` forces Claude’s bash tool to cd back to the project root after each command, preventing directory drift.citeturn0view0
- `BASH_DEFAULT_TIMEOUT_MS=30000` caps default runtime for bash commands at 30 s, keeping runaway tool executions in check.citeturn0view0
- `USE_BUILTIN_RIPGREP=0` and `RIPGREP_CONFIG_PATH=…` ensure Claude defers to our tuned ripgrep install (see `shell/ripgrep/ripgreprc`).citeturn0view0
- `DISABLE_TELEMETRY=1` and `DISABLE_ERROR_REPORTING=1` opt out of non-essential reporting traffic.citeturn0view0

## Permissions & Sandbox Guidance
- Prefer `permissions.deny` rules to hide secrets (e.g. `Read(./.env)`); this replaces the deprecated `ignorePatterns` field.citeturn0view0
- Use the `sandbox` block only if you need Claude’s managed sandbox; filesystem/network access is primarily governed by Read/Edit/WebFetch permission rules.citeturn0view0

## Maintenance Checklist
- Validate edits with `python3 -m json.tool claude/settings.json` before committing.
- When adding new keys, confirm they appear in the official “Available settings” table to avoid no-ops.citeturn0view0
- Document any undocumented-but-working flags (like `alwaysThinkingEnabled`) here so future updates can replace them with supported options.
