#!/bin/bash
# Debug script to see what JSON is being passed to statusline

input=$(cat)

# Save the input to a file for inspection
echo "$input" | jq '.' > /tmp/claude-statusline-debug.json

# Also print what we're getting for tokens
echo "$input" | jq '{tokens, model, workspace}' > /tmp/claude-statusline-tokens.json

# Output something so the statusline still works
echo "[DEBUG MODE] Check /tmp/claude-statusline-debug.json"
