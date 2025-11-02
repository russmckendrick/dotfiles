#!/usr/bin/env zsh

# Claude Code Status Line Script
# Matches the Gruvbox Dark theme from your Starship prompt

# Read JSON input from stdin
input=$(cat)

# Extract information from JSON
model_name=$(echo "$input" | jq -r '.model.display_name')
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir')
version=$(echo "$input" | jq -r '.version')

# Get relative path from project to current dir if they differ
if [[ "$current_dir" != "$project_dir" ]]; then
    rel_path=$(realpath --relative-to="$project_dir" "$current_dir" 2>/dev/null || echo "${current_dir##*/}")
    display_dir="$(basename "$project_dir")/$rel_path"
else
    display_dir=$(basename "$project_dir")
fi

# Get git information if in a git repository
git_info=""
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
        # Check for git status indicators
        git_status=""
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            git_status=" ●"  # Modified files indicator
        fi
        git_info=" ${COLOR_AQUA} ${branch}${git_status}${COLOR_RESET}"
    fi
fi

# Get current time
current_time=$(date +"%H:%M")

# Gruvbox Dark colors (matching your Starship palette)
COLOR_ORANGE="\033[38;2;214;93;14m"
COLOR_YELLOW="\033[38;2;215;153;33m"
COLOR_AQUA="\033[38;2;104;157;106m"
COLOR_BLUE="\033[38;2;69;133;136m"
COLOR_PURPLE="\033[38;2;177;98;134m"
COLOR_FG0="\033[38;2;251;241;199m"
COLOR_RESET="\033[0m"

# Create status line with segments similar to your Starship prompt
printf "${COLOR_ORANGE}󰀵 ${model_name}${COLOR_RESET} ${COLOR_YELLOW}󰲋 ${display_dir}${COLOR_RESET}${git_info} ${COLOR_PURPLE}󰥔 ${current_time}${COLOR_RESET} ${COLOR_AQUA}󰙨 v${version}${COLOR_RESET}"