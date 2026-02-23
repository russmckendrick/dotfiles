# 🏠 Oh My Zsh Configuration
# Path to oh-my-zsh installation and theme selection
export ZSH="/Users/russ.mckendrick/.oh-my-zsh"
plugins=(git macos terraform vscode brew starship sublime 1password)
source $ZSH/oh-my-zsh.sh
ZSH_THEME=""
DEFAULT_USER=$(whoami)

# # 🌟 Starship Configuration
# eval "$(starship init zsh)"

# 🛠️ Environment Setup and Path Configuration
# Set up various environment paths and default configurations
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH=${0:A:h}/bin:$PATH
export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export ANSIBLE_SSH_CONTROL_PATH='/tmp/%%h-%%p-%%r'
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_LOG_PATH="~/.local/ansible.log"
export ANSIBLE_REMOTE_TMP="/tmp"
export NODE_NO_WARNINGS=1
export STARSHIP_CONFIG=~/.dotfiles/starship.toml
export PATH="/Users/russ.mckendrick/.antigravity/antigravity/bin:$PATH"

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# 💻 IDE and Editor Aliases
alias s='open -a "Sublime Text"'
alias v='code '
export PATH="/Users/russ.mckendrick/.codeium/windsurf/bin:$PATH"

# 🐍 Python Configuration
alias pip='python -m pip'

# 🔑 SSH Configuration
# Add SSH keys to the agent at startup
if [ -f ~/.ssh/id_rsa ]; then
  ssh-add -K ~/.ssh/id_rsa 2>/dev/null
fi

# 📝 Blog Aliases and Functions
alias blog="cd ~/Code/blog/ && pnpm run dev"
alias bloge="cursor ~/Code/blog/"
alias blogimg='for file in *; do [[ -f "$file" && ! -f "${file%.*}.meta" ]] && echo "{\n\"Title\": \"${file%.*}\"\n}" > "${file}.meta"; done'

# 📦 pnpm aliases
alias npm='echo "Error: Use pnpm"; false'
alias n="pnpm"
alias ni="pnpm install"

# 🏗️ Ansible Configuration
# Ansible-specific settings and aliases
alias al='ansible-lint -c ~/.config/ansible-lint.yml'
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# ☁️ Terraform Aliases
# Shortcuts for common Terraform commands
alias tfrm="rm -rf .terraform *.tfstate*"
alias tfi="terraform init"
alias tfa="terraform apply -auto-approve"
alias tfd="terraform destroy"

# 📂 File and Directory Navigation
# Enhanced ls commands with colors
colorflag="-G"
alias ls="command ls ${colorflag}"
alias l="ls -lF ${colorflag}"               # all files, in long format
alias la="ls -laF ${colorflag}"             # all files inc dotfiles, in long format
alias lsd='ls -lF ${colorflag} | grep "^d"' # only directories
alias lr="ls -ltr ${colorflag}"
alias lra="ls -ltrA ${colorflag}"

# 🚶 Directory Navigation Shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias tree="tree -I '.git'"

# 📁 Quick Access to Code Directories
alias cod="cd ~/Code/"
alias dt="cd ~/.dotfiles/"

# 🔒 System Administration
# Sudo and system management aliases
alias sudo='sudo '
alias hoste='sudo code /private/etc/hosts'
alias flush='sudo killall -HUP mDNSResponder; sleep 2;'

# 🎨 Syntax Highlighting
# Enhanced cat command with syntax highlighting
alias c='pygmentize -O style=monokai -f console256 -g'

# 📦 Git Shortcuts
# Common Git command aliases
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m' # requires you to type a commit message
alias gp='git push'
alias gpu='git pull'

# 🤖 AI Agent Configuration Tools

# 🔄 CLAUDE.md → AGENTS.md Migration Tool
# Usage: agentsmd
# Migrates CLAUDE.md files to AGENTS.md (the open standard) across a git repo.
# For each CLAUDE.md found:
#   - Renames to AGENTS.md (git mv for tracked, mv for untracked)
#   - Creates a CLAUDE.md → AGENTS.md symlink for backward compatibility
# Also updates .gitignore with CLAUDE.md entries.
# Safe to run repeatedly (idempotent).
function agentsmd() {
    # Colors and formatting
    local RED='\033[0;31m'
    local BLUE='\033[0;34m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local CYAN='\033[0;36m'
    local BOLD='\033[1m'
    local NC='\033[0m' # No Color

    # Verify we're inside a git repository
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo "${RED}❌ Not inside a git repository${NC}"
        return 1
    fi

    local repo_root
    repo_root=$(git rev-parse --show-toplevel)

    echo "\n${BOLD}${BLUE}🤖 CLAUDE.md → AGENTS.md Migration Tool${NC}\n"

    local changes_made=0

    # Discover all CLAUDE.md (regular files only) and AGENTS.md files
    local claude_files=()
    local agents_files=()

    while IFS= read -r -d '' f; do
        claude_files+=("$f")
    done < <(find "$repo_root" -name "CLAUDE.md" -type f -not -path "*/.git/*" -print0 2>/dev/null)

    while IFS= read -r -d '' f; do
        agents_files+=("$f")
    done < <(find "$repo_root" -name "AGENTS.md" -type f -not -path "*/.git/*" -print0 2>/dev/null)

    # Build a set of directories that already have AGENTS.md
    typeset -A agents_dirs
    for f in "${agents_files[@]}"; do
        agents_dirs[$(dirname "$f")]=1
    done

    # Process each CLAUDE.md file
    for claude_file in "${claude_files[@]}"; do
        local dir=$(dirname "$claude_file")
        local agents_file="$dir/AGENTS.md"
        local rel_claude=${claude_file#$repo_root/}
        local rel_agents=${agents_file#$repo_root/}

        if [ -z "${agents_dirs[$dir]}" ]; then
            # Scenario A: Fresh migration — CLAUDE.md exists, no AGENTS.md
            echo "  ${CYAN}📄 $rel_claude${NC} → ${GREEN}$rel_agents${NC}"

            # Check if file is tracked by git
            if git -C "$repo_root" ls-files --error-unmatch "$rel_claude" &>/dev/null; then
                git -C "$repo_root" mv "$claude_file" "$agents_file"
            else
                mv "$claude_file" "$agents_file"
            fi

            # Create backward-compatible symlink
            ln -s "AGENTS.md" "$claude_file"
            echo "  ${GREEN}🔗 Created symlink ${CYAN}$rel_claude${GREEN} → AGENTS.md${NC}"
            changes_made=1
        fi
    done

    # Scenario B: Check directories that already have AGENTS.md
    for agents_file in "${agents_files[@]}"; do
        local dir=$(dirname "$agents_file")
        local claude_file="$dir/CLAUDE.md"
        local rel_claude=${claude_file#$repo_root/}

        if [ -L "$claude_file" ]; then
            local link_target=$(readlink "$claude_file")
            if [ "$link_target" = "AGENTS.md" ]; then
                echo "  ${YELLOW}⏭️  Symlink already correct: ${CYAN}$rel_claude${YELLOW} → AGENTS.md${NC}"
            else
                rm "$claude_file"
                ln -s "AGENTS.md" "$claude_file"
                echo "  ${GREEN}🔗 Fixed symlink ${CYAN}$rel_claude${GREEN} → AGENTS.md${NC}"
                changes_made=1
            fi
        elif [ ! -e "$claude_file" ]; then
            ln -s "AGENTS.md" "$claude_file"
            echo "  ${GREEN}🔗 Created symlink ${CYAN}$rel_claude${GREEN} → AGENTS.md${NC}"
            changes_made=1
        else
            echo "  ${YELLOW}⚠️  ${CYAN}$rel_claude${YELLOW} exists as a regular file alongside AGENTS.md — skipping${NC}"
        fi
    done

    # Update .gitignore
    local gitignore="$repo_root/.gitignore"
    local ignore_updated=0

    if [ ! -f "$gitignore" ]; then
        touch "$gitignore"
        echo "  ${GREEN}📝 Created .gitignore${NC}"
    fi

    if ! grep -qxF "CLAUDE.md" "$gitignore"; then
        echo "CLAUDE.md" >> "$gitignore"
        ignore_updated=1
    fi

    if ! grep -qxF "**/CLAUDE.md" "$gitignore"; then
        echo "**/CLAUDE.md" >> "$gitignore"
        ignore_updated=1
    fi

    if [ $ignore_updated -eq 1 ]; then
        echo "  ${GREEN}📝 Updated .gitignore with CLAUDE.md entries${NC}"
        changes_made=1
    else
        echo "  ${YELLOW}⏭️  .gitignore already has CLAUDE.md entries${NC}"
    fi

    # Summary
    echo ""
    if [ $changes_made -eq 1 ]; then
        echo "${GREEN}✅ Migration complete!${NC}"
    else
        echo "${GREEN}✅ Everything already up to date${NC}"
    fi
}

# 📊 Draw.io Configuration
alias draw.io='/Applications/draw.io.app/Contents/MacOS/draw.io'

# 🐍 Conda Configuration
# Conda initialization and environment management
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# 🐍 Conda Environment Management Functions

# 📋 Interactive Conda Environment Selector
# Usage: cs
# Displays a numbered list of available conda environments
# and allows you to select one to activate using arrow keys.
# Features:
# - Color-coded environment list
# - Base environment highlighting
# - Input validation
function cs() {
    # Colors and formatting
    local BLUE='\033[0;34m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local CYAN='\033[0;36m'
    local BOLD='\033[1m'
    local NC='\033[0m' # No Color
    
    # Get list of conda environments
    local environments=($(conda env list | grep -v '^#' | awk '{print $1}' | grep -v '^$'))
    
    # Print header with styling
    echo "\n${BOLD}${BLUE}🐍 Available Conda Environments:${NC}\n"
    
    # Print environments with numbers and colors
    for i in {1..${#environments[@]}}; do
        if [ "${environments[$i]}" = "base" ]; then
            echo "  ${YELLOW}$i)${NC} ${CYAN}${environments[$i]}${NC} ${GREEN}(base)${NC}"
        else
            echo "  ${YELLOW}$i)${NC} ${CYAN}${environments[$i]}${NC}"
        fi
    done
    
    # Get user selection with styled prompt
    echo "\n${BOLD}${BLUE}Enter environment number (${GREEN}1-${#environments[@]}${BLUE}):${NC} "
    read selection
    
    # Validate input
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#environments[@]}" ]; then
        echo "${GREEN}✓ Activating ${CYAN}${environments[$selection]}${GREEN} environment...${NC}"
        conda activate "${environments[$selection]}"
    else
        echo "${YELLOW}⚠️  Invalid selection${NC}"
    fi
}

# 🗑️ Interactive Conda Environment Removal Tool
# Usage: csrm
# Safely remove conda environments with an interactive prompt
# Features:
# - Color-coded environment list
# - Base environment protection
# - Double confirmation for safety
# - Clear success/failure feedback
function csrm() {
    # Colors and formatting
    local RED='\033[0;31m'
    local BLUE='\033[0;34m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local CYAN='\033[0;36m'
    local BOLD='\033[1m'
    local NC='\033[0m' # No Color
    
    # Get list of conda environments
    local environments=($(conda env list | grep -v '^#' | awk '{print $1}' | grep -v '^$'))
    
    # Print header with styling
    echo "\n${BOLD}${RED}🗑️  Conda Environment Removal Tool${NC}\n"
    
    # Print environments with numbers and colors
    for i in {1..${#environments[@]}}; do
        if [ "${environments[$i]}" = "base" ]; then
            echo "  ${YELLOW}$i)${NC} ${CYAN}${environments[$i]}${NC} ${GREEN}(base)${NC} ⚠️  ${RED}Cannot be removed${NC}"
        else
            echo "  ${YELLOW}$i)${NC} ${CYAN}${environments[$i]}${NC}"
        fi
    done
    
    # Get user selection with styled prompt
    echo "\n${BOLD}${RED}⚠️  Enter environment number to remove (${YELLOW}1-${#environments[@]}${RED}):${NC} "
    read selection
    
    # Validate input and handle base environment
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#environments[@]}" ]; then
        if [ "${environments[$selection]}" = "base" ]; then
            echo "${RED}❌ Cannot remove base environment!${NC}"
            return 1
        fi
        
        echo "${RED}⚠️  WARNING: This will permanently delete the environment '${CYAN}${environments[$selection]}${RED}'${NC}"
        echo "${YELLOW}🤔 Are you sure? (y/N):${NC} "
        read confirm
        
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            echo "${YELLOW}🚮 Removing ${CYAN}${environments[$selection]}${YELLOW} environment...${NC}"
            conda env remove --name "${environments[$selection]}"
            echo "${GREEN}✅ Environment removed successfully!${NC}"
        else
            echo "${BLUE}💡 Operation cancelled${NC}"
        fi
    else
        echo "${RED}❌ Invalid selection${NC}"
    fi
}

# 🎥 Video Processing Tools

# 🎥 Video rename tool
alias videorenamer='python ~/Code/VideoRenamerCLI/rename_videos.py -c ~/Code/VideoRenamerCLI/config.yaml'

# 🎬 YouTube Downloader with Chrome Cookies
# Usage: dlc <video-url>
# Downloads videos using yt-dlp with Chrome browser cookies
# Useful for downloading from sites that require authentication
alias dlc="yt-dlp --cookies-from-browser chrome --extractor-args \"generic:impersonate=chrome\" "

# 🪓 Fix PNG Videos
# Usage: fix_png_videos
# Renames .png files that are actually videos to .mp4
function fix_png_videos() {
    # Check for .png files, (N) prevents error if no files found
    for f in *.png(N); do
        # Check if file content indicates video (ignoring filename)
        if file -b "$f" | grep -qE "video|Media|MP4"; then
            echo "Renaming $f to ${f%.png}.mp4"
            mv "$f" "${f%.png}.mp4"
        fi
    done
}

# 🔄 Video Joiner Tool
# Usage: vidjoin <file_prefix>
# Concatenates multiple MP4 or TS files that share a common file prefix.
# The function searches for files matching <file_prefix>*.mp4 or <file_prefix>*.ts, copies them to a temporary processing directory,
# builds a file list for ffmpeg, and concatenates them using the concat demuxer.
# It also provides error handling and prompts to optionally delete the original files.
function vidjoin() {
    if [ "$#" -eq 0 ]; then
        echo "Usage: vidjoin <file_prefix>"
        return 1
    else
        file_prefix="$1"
    fi

    # Create a temporary processing directory for video concatenation
    PROCESS_DIR="/tmp/vidjoin_processing_$$"
    mkdir -p "$PROCESS_DIR"
    echo "Debug: Working in processing directory: $PROCESS_DIR"

    temp_filelist="$PROCESS_DIR/filelist.txt"
    : > "$temp_filelist"

    # Determine file type (prefer .ts if found, otherwise .mp4)
    local file_ext=""
    local output_ext=""

    if ls ${file_prefix}*.ts >/dev/null 2>&1; then
        file_ext="ts"
        output_ext="mp4"
        echo "Debug: Found TS files matching ${file_prefix}*.ts - copying to processing directory..."
    elif ls ${file_prefix}*.mp4 >/dev/null 2>&1; then
        file_ext="mp4"
        output_ext="mp4"
        echo "Debug: Found MP4 files matching ${file_prefix}*.mp4 - copying to processing directory..."
    else
        echo "No matching MP4 or TS files found for ${file_prefix}"
        rm -rf "$PROCESS_DIR"
        return 1
    fi

    # Copy files to processing directory and build file list
    for f in $(ls -v ${file_prefix}*.${file_ext}); do
        if [[ -f "$f" ]]; then
            cp "$f" "$PROCESS_DIR/"
            echo "file '$(basename "$f")'" >> "$temp_filelist"
            echo "Debug: Copied $f"
        fi
    done

    output_name="${file_prefix}.${output_ext}"
    echo "Debug: Output will be: $output_name"

    pushd "$PROCESS_DIR" > /dev/null

    if [[ -s "$temp_filelist" ]]; then
        echo "Concatenating MP4 files..."
        ffmpeg -f concat -safe 0 -i "$temp_filelist" -c copy "$output_name"
        ffmpeg_status=$?
    else
        echo "Error: No files were added to the list"
        popd > /dev/null
        rm -rf "$PROCESS_DIR"
        return 1
    fi

    popd > /dev/null
    if [ $ffmpeg_status -eq 0 ]; then
        cp "$PROCESS_DIR/$output_name" "./$output_name"
        if [ $? -eq 0 ] && [ -f "./$output_name" ]; then
            echo "Successfully created $output_name"

            echo "The following files will be deleted:"
            for f in $(ls -v ${file_prefix}*.${file_ext}); do
                if [[ "$f" != "$output_name" ]]; then
                    echo "$f"
                fi
            done

            read -q "REPLY?Do you want to delete the original files? (y/n) "
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                for f in $(ls -v ${file_prefix}*.${file_ext}); do
                    if [[ "$f" != "$output_name" ]]; then
                        rm "$f"
                    fi
                done
            fi
        else
            echo "Error: Failed to copy output file back to current directory"
            rm -rf "$PROCESS_DIR"
            return 1
        fi
    else
        echo "Error: ffmpeg failed to process files"
        rm -rf "$PROCESS_DIR"
        return 1
    fi

    rm -rf "$PROCESS_DIR"
}

# 🎨 Video Processing Tool
# Usage: vidpro <input.mp4>
# Process an MP4 file while preserving video and audio codecs
# Features:
# - Creates output with '-pro' suffix
# - Preserves original codecs (no re-encoding)
# - Interactive cleanup option:
#   - Remove original file, or
#   - Rename original to '-raw' suffix
# Example: vidpro recording.mp4 creates recording-pro.mp4
function vidpro() {
    if [ "$#" -eq 0 ]; then
        echo "No file specified. Usage: process_videos 'filename.mp4'"
        return 1
    fi

    file=$1

    if [ ! -f "$file" ]; then
        echo "File not found: $file"
        return 1
    fi

    output_file="${file/%.mp4/-pro.mp4}"

    ffmpeg -i "$file" -vcodec copy -acodec copy "$output_file"

    if [ $? -eq 0 ]; then
        echo "Processed: $output_file"
        
        echo "Do you want to remove the original file? (y/N)"
        read -r remove_original

        if [[ $remove_original =~ ^[Yy]$ ]]; then
            rm "$file"
            echo "Original file removed: $file"
        else
            raw_file="${file/%.mp4/-raw.mp4}"
            mv "$file" "$raw_file"
            echo "Original file renamed to: $raw_file"
        fi
    else
        echo "Failed to process: $file"
        return 1
    fi
}

# 🌐 Network Tools

# 🔌 Interactive Dev Server Port Manager
# Usage: ports
# Displays a numbered list of node/python processes listening on TCP ports
# and allows you to select one to kill.
# Features:
# - Filters to node and python processes only
# - Color-coded process list
# - Shows PID, process name, port, and user
# - Confirmation before killing
# - Input validation
function ports() {
    # Colors and formatting
    local RED='\033[0;31m'
    local BLUE='\033[0;34m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local CYAN='\033[0;36m'
    local BOLD='\033[1m'
    local NC='\033[0m' # No Color

    # Get listening node/python processes (skip header line, filter by command name)
    local raw_lines=("${(@f)$(lsof -iTCP -sTCP:LISTEN -P -n 2>/dev/null | tail -n +2 | grep -iE '^(node|python)')}")

    if [ ${#raw_lines[@]} -eq 0 ] || [ -z "${raw_lines[1]}" ]; then
        echo "\n${BOLD}${BLUE}🌐 No node/python dev servers listening${NC}\n"
        return 0
    fi

    # Deduplicate by PID:PORT, collect display info
    typeset -A seen
    local pids=()
    local names=()
    local port_list=()
    local users=()

    for line in "${raw_lines[@]}"; do
        local pname=$(echo "$line" | awk '{print $1}')
        local pid=$(echo "$line" | awk '{print $2}')
        local user=$(echo "$line" | awk '{print $3}')
        local port=$(echo "$line" | awk '{print $9}' | sed 's/.*://')
        local key="${pid}:${port}"

        if [ -z "${seen[$key]}" ]; then
            seen[$key]=1
            pids+=("$pid")
            names+=("$pname")
            port_list+=("$port")
            users+=("$user")
        fi
    done

    # Print header with styling
    echo "\n${BOLD}${BLUE}🌐 Dev Servers Listening on TCP Ports:${NC}\n"

    # Print processes with numbers and colors
    for i in {1..${#pids[@]}}; do
        echo "  ${YELLOW}$i)${NC} ${CYAN}${names[$i]}${NC} (PID: ${GREEN}${pids[$i]}${NC}) → port ${BOLD}${port_list[$i]}${NC} [${BLUE}${users[$i]}${NC}]"
    done

    # Get user selection with styled prompt
    echo "\n${BOLD}${BLUE}Enter number to kill (${GREEN}1-${#pids[@]}${BLUE}) or ${YELLOW}q${BLUE} to quit:${NC} "
    read selection

    # Handle quit
    if [[ -z "$selection" || "$selection" == "q" ]]; then
        echo "${BLUE}💡 No action taken${NC}"
        return 0
    fi

    # Validate input
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#pids[@]}" ]; then
        echo "${RED}⚠️  Kill ${CYAN}${names[$selection]}${RED} (PID: ${GREEN}${pids[$selection]}${RED}) on port ${BOLD}${port_list[$selection]}${RED}? (y/N):${NC} "
        read confirm

        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            kill -9 "${pids[$selection]}" 2>/dev/null
            if [ $? -eq 0 ]; then
                echo "${GREEN}✅ Process ${CYAN}${names[$selection]}${GREEN} (PID: ${pids[$selection]}) killed${NC}"
            else
                echo "${RED}❌ Failed to kill process. Try running with sudo.${NC}"
            fi
        else
            echo "${BLUE}💡 Operation cancelled${NC}"
        fi
    else
        echo "${RED}❌ Invalid selection${NC}"
    fi
}

# 📜 History Configuration
# ZSH history settings for better command history management
HISTORY_IGNORE="(|(*/.vscode/extensions/*)|(vidjoin *))"

# Optional: Use zshaddhistory function for more precise control
zshaddhistory() {
  emulate -L zsh
  [[ $1 != *(/.vscode/extensions/)* && $1 != vidjoin* ]]
}

# Set history options
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
export PATH="$HOME/.local/bin:$PATH"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/russ.mckendrick/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions


# pnpm
export PNPM_HOME="/Users/russ.mckendrick/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
