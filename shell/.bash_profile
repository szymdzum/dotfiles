# Load Codex alias bootstrap when running inside the Codex sandbox
if { [ -n "${CODEX_SANDBOX:-}" ] || [ -n "${CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR:-}" ]; } \
  && [ -f "$HOME/.config/codex/bash-agent-aliases.sh" ]; then
  # shellcheck source=$HOME/.config/codex/bash-agent-aliases.sh
  . "$HOME/.config/codex/bash-agent-aliases.sh"
fi
