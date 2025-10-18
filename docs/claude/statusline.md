# STATUS LINE CONFIGURATION

Create a custom status line for Claude Code to display contextual information

Make Claude Code your own with a custom status line that displays at the bottom of the Claude Code interface, similar to how terminal prompts (PS1) work in shells like Oh-my-zsh.

## CREATE A CUSTOM STATUS LINE

You can either:

*   Run `/statusline` to ask Claude Code to help you set up a custom status line. By default, it will try to reproduce your terminal’s prompt, but you can provide additional instructions about the behavior you want to Claude Code, such as `/statusline show the model name in orange`
*   Directly add a `statusLine` command to your `.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0 // Optional: set to 0 to let status line go to edge
  }
}
```

## HOW IT WORKS

*   The status line is updated when the conversation messages update
*   Updates run at most every 300ms
*   The first line of stdout from your command becomes the status line text
*   ANSI color codes are supported for styling your status line
*   Claude Code passes contextual information about the current session (model, directories, etc.) as JSON to your script via stdin

## JSON INPUT STRUCTURE

Your status line command receives structured data via stdin in JSON format:

```json
{
  "session_id": "d8ea1f04-2cbb-4bdd-9735-bd6f60117806",
  "transcript_path": "/Users/user/.claude/projects/-Users-user-project/session.jsonl",
  "cwd": "/Users/user/project",
  "model": {
    "id": "claude-sonnet-4-5-20250929",
    "display_name": "Sonnet 4.5"
  },
  "workspace": {
    "current_dir": "/Users/user/project",
    "project_dir": "/Users/user/project"
  },
  "version": "2.0.19",
  "output_style": {
    "name": "default"
  },
  "cost": {
    "total_cost_usd": 0.01234,
    "total_duration_ms": 45000,
    "total_api_duration_ms": 2300,
    "total_lines_added": 156,
    "total_lines_removed": 23
  },
  "exceeds_200k_tokens": false
}
```

### Available Fields

- **`session_id`** - Unique identifier for the current session
- **`transcript_path`** - Full path to the conversation transcript JSONL file
- **`cwd`** - Current working directory
- **`model.id`** - Full model identifier (e.g., "claude-sonnet-4-5-20250929")
- **`model.display_name`** - Human-readable model name (e.g., "Sonnet 4.5")
- **`workspace.current_dir`** - Current working directory
- **`workspace.project_dir`** - Original project directory (where Claude Code was started)
- **`version`** - Claude Code version (e.g., "2.0.19")
- **`output_style.name`** - Name of the current output style
- **`cost.total_cost_usd`** - Total conversation cost in USD
- **`cost.total_duration_ms`** - Total elapsed time in milliseconds
- **`cost.total_api_duration_ms`** - Time spent in API calls in milliseconds
- **`cost.total_lines_added`** - Total lines of code added in the session
- **`cost.total_lines_removed`** - Total lines of code removed in the session
- **`exceeds_200k_tokens`** - Boolean indicating if context window limit has been exceeded

**Note:** Token usage details (`tokens.used` and `tokens.total`) are **not currently exposed** by Claude Code. The `exceeds_200k_tokens` boolean field indicates if the context window has been exceeded, but exact token counts are not available.

## EXAMPLE SCRIPTS

### SIMPLE STATUS LINE

```bash
#!/bin/bash
# Read JSON input from stdin
input=$(cat)

# Extract values using jq
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

echo "[$MODEL_DISPLAY] 📁 ${CURRENT_DIR##*/}"
```

### GIT-AWARE STATUS LINE

```bash
#!/bin/bash
# Read JSON input from stdin
input=$(cat)

# Extract values using jq
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

# Show git branch if in a git repo
GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH=" | 🌿 $BRANCH"
    fi
fi

echo "[$MODEL_DISPLAY] 📁 ${CURRENT_DIR##*/}$GIT_BRANCH"
```

### PYTHON EXAMPLE

```python
#!/usr/bin/env python3
import json
import sys
import os

# Read JSON from stdin
data = json.load(sys.stdin)

# Extract values
model = data['model']['display_name']
current_dir = os.path.basename(data['workspace']['current_dir'])

# Check for git branch
git_branch = ""
if os.path.exists('.git'):
    try:
        with open('.git/HEAD', 'r') as f:
            ref = f.read().strip()
            if ref.startswith('ref: refs/heads/'):
                git_branch = f" | 🌿 {ref.replace('ref: refs/heads/', '')}"
    except:
        pass

print(f"[{model}] 📁 {current_dir}{git_branch}")
```

### NODE.JS EXAMPLE

```javascript
#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Read JSON from stdin
let input = '';
process.stdin.on('data', chunk => input += chunk);
process.stdin.on('end'), () => {
    const data = JSON.parse(input);
    
    // Extract values
    const model = data.model.display_name;
    const currentDir = path.basename(data.workspace.current_dir);
    
    // Check for git branch
    let gitBranch = '';
    try {
        const headContent = fs.readFileSync('.git/HEAD', 'utf8').trim();
        if (headContent.startsWith('ref: refs/heads/')) {
            gitBranch = ` | 🌿 ${headContent.replace('ref: refs/heads/', '')}`;
        }
    } catch (e) {
        // Not a git repo or can't read HEAD
    }
    
    console.log(`[${model}] 📁 ${currentDir}${gitBranch}`);
});
```

### WITH COST AND PERFORMANCE METRICS

Show conversation cost and performance:

```bash
#!/bin/bash
# Read JSON input from stdin
input=$(cat)

# Extract values using jq
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd')
LINES_ADDED=$(echo "$input" | jq -r '.cost.total_lines_added')
LINES_REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed')

# Format cost display
COST_INFO=""
if [ "$COST" != "null" ] && [ "$COST" != "0" ]; then
    COST_FORMATTED=$(printf "%.4f" $COST)
    COST_INFO=" | \$${COST_FORMATTED}"
fi

# Show lines changed
LINES_INFO=""
if [ "$LINES_ADDED" != "null" ] || [ "$LINES_REMOVED" != "null" ]; then
    LINES_INFO=" | +${LINES_ADDED}/-${LINES_REMOVED}"
fi

echo "[$MODEL_DISPLAY] 📁 ${CURRENT_DIR##*/}${COST_INFO}${LINES_INFO}"
```

### WITH CONTEXT WARNING

Show a warning when approaching context limits:

```bash
#!/bin/bash
# Read JSON input from stdin
input=$(cat)

# Extract values using jq
MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
EXCEEDS_200K=$(echo "$input" | jq -r '.exceeds_200k_tokens')

# Show warning if exceeds 200k
CONTEXT_WARNING=""
if [ "$EXCEEDS_200K" = "true" ]; then
    CONTEXT_WARNING=" ⚠️  CONTEXT LIMIT"
fi

echo "[$MODEL_DISPLAY] 📁 ${CURRENT_DIR##*/}${CONTEXT_WARNING}"
```

### COLORFUL WITH GIT STATUS

Clean statusline with color variation and git dirty indicator:

```bash
#!/bin/bash
# Read JSON input from stdin
input=$(cat)

# Extract basic info
current_dir="$(echo "$input" | jq -r '.workspace.current_dir')"
model="$(echo "$input" | jq -r '.model.display_name')"
branch="$(cd "$current_dir" 2>/dev/null && git branch --show-current 2>/dev/null)"

# Check for uncommitted changes (if in a git repo)
dirty_marker=""
if [ -n "$branch" ]; then
    cd "$current_dir" 2>/dev/null
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        dirty_marker="*"
    fi
fi

# Simplify path (replace home with ~)
display_path="${current_dir/#$HOME/~}"

# Colors
orange='\033[38;2;204;85;0m'   # Claude orange
cyan='\033[38;2;0;168;232m'    # Cyan for branch
reset='\033[0m'

# Build statusline
branch_display=""
if [ -n "$branch" ]; then
    branch_display=" ${cyan}(${branch}${dirty_marker})${reset}"
fi

printf "%b%b %b%b%b\n" "$orange" "$display_path" "$reset" "$branch_display" "$orange" "$model" "$reset"
```

Output: `~/Developer/dotfiles (main*) Sonnet 4.5` (with colors: path in orange, branch in cyan, model in orange, * appears when there are uncommitted changes)

### HELPER FUNCTION APPROACH

For more complex bash scripts, you can create helper functions:

```bash
#!/bin/bash
# Read JSON input once
input=$(cat)

# Helper functions for common extractions
get_model_name() { echo "$input" | jq -r '.model.display_name'; }
get_current_dir() { echo "$input" | jq -r '.workspace.current_dir'; }
get_project_dir() { echo "$input" | jq -r '.workspace.project_dir'; }
get_version() { echo "$input" | jq -r '.version'; }
get_cost() { echo "$input" | jq -r '.cost.total_cost_usd'; }
get_duration() { echo "$input" | jq -r '.cost.total_duration_ms'; }
get_lines_added() { echo "$input" | jq -r '.cost.total_lines_added'; }
get_lines_removed() { echo "$input" | jq -r '.cost.total_lines_removed'; }

# Use the helpers
MODEL=$(get_model_name)
DIR=$(get_current_dir)
echo "[$MODEL] 📁 ${DIR##*/}"
```

## TIPS

*   Keep your status line concise - it should fit on one line
*   Use emojis (if your terminal supports them) and colors to make information scannable
*   Use `jq` for JSON parsing in Bash (see examples above)
*   Test your script by running it manually with mock JSON input: `echo '{"model":{"display_name":"Test"},"workspace":{"current_dir":"/test"}}' | ./statusline.sh`
*   Consider caching expensive operations (like git status) if needed

## TROUBLESHOOTING

*   If your status line doesn’t appear, check that your script is executable (`chmod +x`)
*   Ensure your script outputs to stdout (not stderr)