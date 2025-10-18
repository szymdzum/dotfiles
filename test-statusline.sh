#!/bin/bash
input=$(cat)

current_dir="$(echo "$input" | jq -r '.workspace.current_dir')"
model="$(echo "$input" | jq -r '.model.display_name')"
branch="$(cd "$current_dir" 2>/dev/null && git branch --show-current 2>/dev/null)"

# Try to get tokens
tokens_used="$(echo "$input" | jq -r '.tokens.used // "N/A"')"
tokens_total="$(echo "$input" | jq -r '.tokens.total // "N/A"')"

# Show everything for debugging
token_debug="[tokens_used=$tokens_used tokens_total=$tokens_total]"

printf "$(whoami)@$(hostname -s):$(basename "$current_dir")${branch:+ ($branch)} [${model}] ${token_debug}"
