#!/bin/bash

input=$(cat)

# Extract values from JSON
MODEL=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size')
CURRENT_USAGE=$(echo "$input" | jq '.context_window.current_usage')

# Calculate context remaining
if [ "$CURRENT_USAGE" != "null" ]; then
    CURRENT_TOKENS=$(echo "$CURRENT_USAGE" | jq '.input_tokens + .output_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
    REMAINING=$((CONTEXT_SIZE - CURRENT_TOKENS))
    REMAINING_K=$((REMAINING / 1000))
    CONTEXT_INFO="${REMAINING_K}k left"
else
    CONTEXT_INFO="--"
fi

# Get git branch if in a repo
GIT_BRANCH=""
if git -C "$CURRENT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git -C "$CURRENT_DIR" branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH=" ($BRANCH)"
    fi
fi

# Format: Model | Context | dir (branch)
printf '\033[33m%s\033[0m | %s | \033[34m%s\033[0m%s' "$MODEL" "$CONTEXT_INFO" "$CURRENT_DIR" "$GIT_BRANCH"
