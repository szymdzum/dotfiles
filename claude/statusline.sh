#!/bin/bash
# Claude Code statusline script
# Clean, spread-out format: ~/path (branch)    model

input=$(cat)

# Extract basic info
current_dir="$(echo "$input" | jq -r '.workspace.current_dir')"
model="$(echo "$input" | jq -r '.model.display_name')"
branch="$(cd "$current_dir" 2>/dev/null && git branch --show-current 2>/dev/null)"

# Check for uncommitted changes (if in a git repo)
dirty_marker=""
if [ -n "$branch" ]; then
    cd "$current_dir" 2>/dev/null
    # Update the index to avoid false positives
    git update-index --refresh -q 2>/dev/null
    # Check if there are any uncommitted changes (staged or unstaged)
    if ! git diff-index --quiet HEAD -- 2>/dev/null || ! git diff-files --quiet 2>/dev/null; then
        dirty_marker="*"
    fi
fi

# Simplify path (replace home with ~)
display_path="${current_dir/#$HOME/~}"

# Colors
orange='\033[38;2;204;85;0m'       # Claude orange (RGB: 204, 85, 0)
light_gray='\033[38;2;150;150;150m' # Light gray for path
dark_green='\033[38;2;60;100;70m'   # Very muted dark green for clean branch
dim_yellow='\033[38;2;120;115;90m'  # Extremely muted yellow for dirty branch
reset='\033[0m'

# Build left side: path (branch*) with colors
branch_display=""
branch_color="$dark_green"
if [ -n "$branch" ]; then
    # Use extremely muted yellow if dirty, dark green if clean
    if [ -n "$dirty_marker" ]; then
        branch_color="$dim_yellow"
    fi
    branch_display=" ${branch_color}(${branch}${dirty_marker})${reset}"
fi

left="${light_gray}${display_path}${reset}${branch_display}"

# Build right side: model in orange
right="${orange}${model}${reset}"

# Build the statusline without spacing
printf "%b %b\n" "$left" "$right"
