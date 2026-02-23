# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal macOS dotfiles repository managed with GNU Stow. The repository contains shell configuration, aliases, functions, and custom tools for a development environment centered around zsh, Oh My Zsh, Starship prompt, and various development tools.

## Architecture

### Dotfile Management with Stow

This repository uses GNU Stow for symlink-based dotfile deployment. Files in the root directory are symlinked to the home directory when `stow .` is run from `~/.dotfiles/`.

**Stow Ignore Patterns** (`.stow-local-ignore`):
- System files (`.DS_Store`, `.git`)
- Documentation and assets (`README.*`, `assets/`, `backups/`, `iterm2_profile/`)
- Configuration files (`starship.toml`, `CLAUDE.md`)

### Shell Configuration Structure

The `.zshrc` file is organized into clearly marked sections with emoji headers:
1. Oh My Zsh setup and plugin configuration
2. Environment paths (Python, Ruby, Homebrew, Ansible, Node)
3. IDE/editor aliases
4. SSH configuration
5. Domain-specific aliases and functions (Hugo blog, Ansible, Terraform, Git)
6. Navigation shortcuts
7. Conda environment management
8. Video processing tools
9. History configuration

### Starship Prompt

Uses a custom Starship configuration (`starship.toml`) with:
- Gruvbox Dark color palette
- Multi-segment format showing OS, user, directory, git status, language environments, time, battery, duration
- Support for Docker, Kubernetes, Conda environments

## Key Configuration Files

- `.zshrc`: Main shell configuration (407 lines) - heavily customized with domain-specific functions
- `starship.toml`: Starship prompt configuration (265 lines)
- `.gitconfig`: Git configuration with LFS support, default branch `main`
- `clean_zsh_history.sh`: Script to remove unwanted history entries

## Development Workflow

### Deployment

Deploy dotfiles to home directory:
```bash
cd ~/.dotfiles
stow .
```

### Testing Changes

After modifying shell configuration:
```bash
source ~/.zshrc
```

### Backups

The `backups/` directory contains previous versions of configuration files. When making significant changes to `.zshrc` or `.zprofile`, consider backing up first.

### History Management

The repository includes custom history filtering to exclude:
- `.vscode/extensions/` paths (set in `HISTORY_IGNORE`)
- `vidjoin` commands (via `zshaddhistory` hook)

Use `clean_zsh_history.sh` to clean existing history.

## Custom Functions and Tools

### Conda Environment Management

- `cs`: Interactive environment selector with colored output
- `csrm`: Safe environment removal with base environment protection

### Video Processing Functions

- `vidjoin <prefix>`: Concatenates MP4/TS files with common prefix using ffmpeg
- `vidpro <file.mp4>`: Process video preserving codecs, interactive cleanup
- `dlc <url>`: Download videos using yt-dlp with Chrome cookies
- `videorenamer`: Wrapper for external Python video renaming tool

### Blog Management

Aliases assume a blog at `~/Code/blog/`:
- `blog`: Start dev server
- `bloge`: Open in Cursor editor
- `blogimg`: Generate meta files for images

## Development Environment

### Required Tools

Core tools expected by the configuration:
- Oh My Zsh with plugins: git, macos, terraform, vscode, brew, starship, sublime, 1password
- Starship prompt
- GNU Stow
- zoxide (directory jumper)
- Homebrew
- Conda/Miniconda
- ffmpeg and yt-dlp (for video processing)
- GitHub CLI (`gh`) with copilot extension
- Docker with CLI completions
- thefuck (command correction)
- pygments (syntax highlighting via `c` alias)

### Editor Configuration

Terminal font should be set to "Hack Nerd Font Mono" in IDEs for proper icon rendering in Starship prompt.

## Important Notes

### Path Configuration

Multiple paths are configured in `.zshrc`:
- Pyenv: `$HOME/.pyenv/bin`
- Ruby gems: `$HOME/gems/bin`
- Local bin: `$HOME/.local/bin`
- Codeium Windsurf: `~/.codeium/windsurf/bin`
- Docker completions: `~/.docker/completions`

### Ansible Configuration

Custom Ansible settings for macOS compatibility:
- `OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES` (fixes macOS fork issues)
- Custom SSH control path, log path, and remote temp directory
- Alias `al` for ansible-lint with custom config

### Git Configuration

Default branch is `main`. User configuration:
- Name: russmckendrick
- Email: github@mckendrick.email
- Global gitignore: `~/.dotfiles/.gitignore`

## When Making Changes

1. Test shell configuration changes by sourcing `.zshrc` before committing
2. Respect the emoji-based section organization in `.zshrc`
3. New functions should include usage comments matching existing style
4. Add files that shouldn't be stowed to `.stow-local-ignore`
5. Video processing functions use `/tmp/` for temporary processing - ensure cleanup on errors
