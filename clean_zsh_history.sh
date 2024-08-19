#!/bin/zsh

# Backup the original history file
cp ~/.zsh_history ~/.zsh_history_backup

# Remove lines containing .vscode/extensions
grep -v '\.vscode/extensions/' ~/.zsh_history > ~/.zsh_history_temp

# Move the cleaned history file back
mv ~/.zsh_history_temp ~/.zsh_history

# Clear the history in the current session
fc -p

# Reset the history by reading the cleaned file
fc -R ~/.zsh_history

echo "History cleaned. A backup of the original history is saved as ~/.zsh_history_backup"
echo "Your current session's history has been updated."