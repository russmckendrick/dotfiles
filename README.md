# Dotfiles

![Screenshot](https://raw.github.com/russmckendrick/dotfiles/master/assets/screenshot.png)

## Installation

See the following blog posts
 - https://www.russ.cloud/2014/08/10/dotfiles/ (from 2014)
 - https://www.russ.cloud/2024/04/02/updating-my-dotfiles/ (from 2024)

## Basic Settings

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font starship
brew install tree pygments conda ffmpeg yt-dlp visual-studio-code drawio thefuck stow zoxide gh claude-code
gh extension install github/gh-copilot # enable the gh-copilot  extension
gh copilot alias -- zsh # run one and accept the t&cs
conda config --set changeps1 False
```

For IDEs update the `terminal.integrated.fontFamily` setting to `Hack Nerd Font Mono`.

## Deploying Dotfiles

Deploy the dotfiles using GNU Stow:

```bash
cd ~/.dotfiles

# Stow main dotfiles (.zshrc, .gitconfig, etc.)
stow .

# Stow Claude Code configuration separately
stow claude
```

The `stow .` command deploys all dotfiles except the `claude/` directory, which is stowed separately to keep the Claude Code configuration as an independent package.

## Claude Code Setup

The dotfiles include Claude Code configuration with:
 - Custom Gruvbox Dark statusline (matches Starship prompt)
 - React UI Developer agent for component development
 - MCP server configurations
 - Global Claude Code settings

**Before stowing**, backup your existing Claude Code configuration:

```bash
mkdir -p backups/claude_$(date +%Y%m%d_%H%M%S) && \
cp -r ~/.claude backups/claude_$(date +%Y%m%d_%H%M%S)/.claude && \
cp -r ~/Library/Application\ Support/Claude backups/claude_$(date +%Y%m%d_%H%M%S)/Library_Application_Support_Claude
```

**Note:** Runtime data (history, projects, debug logs) stays local and is not synced.

## See it action

[![asciicast](https://asciinema.org/a/PTUqbpxikms7nFWNs4R7OhMQR.svg)](https://asciinema.org/a/PTUqbpxikms7nFWNs4R7OhMQR)

## Bashstrap

This started as my fork of [Bashstrap](https://github.com/barryclark/bashstrap).