# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for managing macOS shell configuration, terminal customization, and development environment setup. The configuration is designed to be deployed using GNU Stow for symlink management.

## Key Files and Their Purpose

- `.zshrc`: Main ZSH configuration with extensive aliases, functions, and environment setup
- `.gitconfig`: Git configuration with user details and LFS filter settings
- `starship.toml`: Starship prompt configuration with Gruvbox Dark theme and custom segments
- `.p10k.zsh`: Powerlevel10k theme configuration (legacy, Starship is currently active)
- `clean_zsh_history.sh`: Utility script to clean ZSH history of unwanted entries

## Installation and Deployment

The repository uses GNU Stow for managing dotfiles. Based on the README, installation requires:

```bash
# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install fonts and dependencies
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font starship
brew install tree pygments conda ffmpeg yt-dlp visual-studio-code drawio thefuck stow zoxide gh

# Setup GitHub Copilot CLI
gh extension install github/gh-copilot
gh copilot alias -- zsh

# Configure conda
conda config --set changeps1 False

# Deploy dotfiles (typically using stow from parent directory)
# stow -t ~/ dotfiles
```

## Architecture and Configuration

### Shell Configuration Architecture

The `.zshrc` file is organized into logical sections (marked with emoji comments):

1. **Oh My Zsh Setup** (lines 1-7): Core Oh My Zsh configuration with plugins
2. **Environment Setup** (lines 12-25): PATH configuration, tool paths, environment variables
3. **IDE/Editor Aliases** (lines 34-37): Quick access to editors (Sublime, VS Code, Windsurf)
4. **Python Configuration** (lines 39-40): Python-specific settings
5. **SSH Configuration** (lines 42-46): SSH key management
6. **Blog Management** (lines 48-51): Hugo blog workflow aliases and functions
7. **Ansible Configuration** (lines 53-56): Ansible environment variables and linting
8. **Terraform Aliases** (lines 58-63): Common Terraform workflow shortcuts
9. **File Navigation** (lines 65-84): Enhanced ls commands and directory shortcuts
10. **Git Shortcuts** (lines 96-102): Common Git command aliases
11. **Conda Environment Management** (lines 109-229): Interactive conda environment selection and removal functions
12. **Video Processing Tools** (lines 231-388): Complex video manipulation functions using ffmpeg

### Starship Prompt Configuration

The `starship.toml` uses a custom Gruvbox Dark color palette with segments for:

- OS, username, directory, git status
- Programming language detection (Node.js, Python, Rust, Go, etc.)
- Kubernetes, Docker, Conda contexts
- Battery status, command duration, job count, time
- Custom fill character for spacing

### Key Custom Functions

**Conda Management:**

- `cs`: Interactive conda environment selector with colored output
- `csrm`: Safe conda environment removal with confirmation and base environment protection

**Video Processing:**

- `vidjoin <prefix>`: Concatenates multiple video files (MP4/TS) with the same prefix using ffmpeg
- `vidpro <file>`: Processes MP4 files while preserving codecs, with cleanup options
- `dlc <url>`: Downloads videos using yt-dlp with Chrome cookies for authenticated sites

### Important Aliases

**Development:**

- `blog`: Start Hugo development server for blog
- `bloge`: Open blog in Cursor editor
- `v`: Open in VS Code
- `s`: Open in Sublime Text

**Terraform:**

- `tfi`: terraform init
- `tfa`: terraform apply -auto-approve
- `tfd`: terraform destroy
- `tfrm`: Clean Terraform state and cache files

**Git:**

- `gs`: git status
- `ga`: git add .
- `gc`: git commit -m
- `gp`: git push
- `gpu`: git pull

**Navigation:**

- `cod`: cd ~/Code/
- `dt`: cd ~/.dotfiles/

## Environment Variables

Key environment variables set in `.zshrc`:

- `STARSHIP_CONFIG`: Points to ~/.dotfiles/starship.toml
- `ANSIBLE_LOG_PATH`: ~/.local/ansible.log
- `ANSIBLE_HOST_KEY_CHECKING`: False
- `NODE_NO_WARNINGS`: 1
- `PYENV_ROOT`: $HOME/.pyenv
- Various PATH additions for local bins, gems, pyenv, Windsurf

## Git Configuration

- Default branch: `main`
- Global gitignore: `~/.dotfiles/.gitignore`
- Git LFS enabled
- User configured as: russmckendrick <github@mckendrick.email>

## Claude Code Configuration

The `claude/` stow package contains Claude Code CLI and Desktop app configurations:

### File Structure

```
claude/
├── .claude/
│   ├── settings.json              # Global Claude Code CLI settings
│   ├── statusline-command.sh      # Custom Gruvbox Dark statusline
│   ├── agents/
│   │   └── react-ui-developer.md  # Custom React UI agent
│   ├── plugins/
│   │   └── config.json            # Plugin configuration
│   └── local/
│       └── package.json           # npm dependencies (run npm install)
└── Library/Application Support/Claude/
    └── claude_desktop_config.json # MCP servers (lighthouse, cloudflare)
```

### Configuration Hierarchy

Claude Code uses cascading settings (highest to lowest priority):

1. Command-line arguments
2. Local project settings (`.claude/settings.local.json` - never version controlled)
3. Shared project settings (`.claude/settings.json` - can be shared with team)
4. User global settings (`~/.claude/settings.json` - in dotfiles)

### Custom Agents

The `react-ui-developer.md` agent is a specialized agent for React component development with shadcn styling. Custom agents are defined using markdown with YAML frontmatter.

### MCP Servers

MCP (Model Context Protocol) servers provide external integrations:

- **lighthouse**: Web performance auditing
- **cloudflare**: Cloudflare API integration

These are configured in `claude_desktop_config.json` and use `npx` for execution.

### Statusline Customization

The `statusline-command.sh` provides a custom status line that matches the Gruvbox Dark theme used in Starship. It displays project context and workspace information.

### Installation

Install Claude Code via Homebrew:

```bash
brew install --cask claude-code
```

### Post-Installation

After installing Claude Code, deploy the configuration using Stow:

```bash
# Deploy Claude Code configuration (from dotfiles directory)
stow claude
```

The `stow claude` command creates symlinks from the `claude/` package to your home directory, deploying both CLI settings (`~/.claude/`) and Desktop app configuration (`~/Library/Application Support/Claude/`).

### What's NOT Version Controlled

Runtime data stays local (excluded via `.stow-local-ignore` and `.gitignore`):

- `~/.claude/history.jsonl` - Command history
- `~/.claude/projects/` - Project metadata
- `~/.claude/local/node_modules/` - npm packages
- `~/.claude/file-history/` - File change tracking
- Debug logs, session data, IDE integration state

### Modifying Claude Code Configuration

1. **Adding custom slash commands**: Create `.md` files in `~/.claude/commands/` (currently no custom commands)
2. **Creating new agents**: Add `.md` files with YAML frontmatter to `~/.claude/agents/`
3. **Configuring MCP servers**: Edit `claude_desktop_config.json` in the stow package
4. **Changing global settings**: Edit `settings.json` in the stow package
5. **Customizing statusline**: Modify `statusline-command.sh`

After making changes in the stow package, restow to update symlinks.

## Testing and Validation

There are no automated tests for shell configurations. Manual validation involves:

- Sourcing `.zshrc` and checking for errors: `source ~/.zshrc`
- Testing individual functions and aliases
- Verifying Starship prompt renders correctly

## Common Modifications

When modifying this repository:

1. **Adding new aliases**: Add to appropriate section in `.zshrc` with emoji-prefixed comment
2. **Adding new functions**: Follow the existing pattern with usage documentation in comments
3. **Modifying prompt**: Edit `starship.toml` - test with `starship config`
4. **Git settings**: Update `.gitconfig` - changes affect global Git behavior
5. **History filtering**: Update `HISTORY_IGNORE` pattern in `.zshrc` or modify `clean_zsh_history.sh`

## Dependencies

Core tools expected to be installed:

- Oh My Zsh framework
- Starship prompt
- Homebrew package manager
- zoxide (for enhanced cd)
- ffmpeg (for video processing)
- yt-dlp (for video downloading)
- conda (for Python environment management)
- GitHub CLI (`gh`) with Copilot extension
- Node.js (various development tasks)
- Ansible (infrastructure automation)
- Terraform (infrastructure as code)
