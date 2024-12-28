# 🚀 Powerlevel10k Instant Prompt
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 🏠 Oh My Zsh Configuration
# Path to oh-my-zsh installation and theme selection
export ZSH="/Users/russ.mckendrick/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git ansible docker macos terraform vscode gh brew)
source $ZSH/oh-my-zsh.sh
DEFAULT_USER=$(whoami)

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

# 🔧 Tool Initialization
# Initialize helpful command-line tools
if command -v thefuck 1>/dev/null 2>&1; then
  eval $(thefuck --alias)
fi

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

# 📝 Hugo Blog Aliases and Functions
alias blog="cd ~/Code/blog/ && hugo server --buildDrafts --buildFuture"
alias bloge="code ~/Code/blog/"
alias blogimg='for file in *; do [[ -f "$file" && ! -f "${file%.*}.meta" ]] && echo "{\n\"Title\": \"${file%.*}\"\n}" > "${file}.meta"; done'

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

# 📊 Draw.io Configuration
alias draw.io='/Applications/draw.io.app/Contents/MacOS/draw.io'

# 🎯 Powerlevel10k Theme Configuration
[[ ! -f ~/.dotfiles/.p10k.zsh ]] || source ~/.dotfiles/.p10k.zsh

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

# 💿 Discogs Collection Generator
# Usage: scrape
# Automatically generates your Discogs collection data
# - Activates dedicated 'discogs' conda environment
# - Runs Python scraper with no delay
# - Deactivates environment when complete
function scrape() {
    cd ~/Code/discogs/
    conda activate discogs
    python discogs_scraper.py --all --delay=0
    conda deactivate
}

# 🎥 Video Processing Tools

# 🎬 YouTube Downloader with Chrome Cookies
# Usage: dlc <video-url>
# Downloads videos using yt-dlp with Chrome browser cookies
# Useful for downloading from sites that require authentication
alias dlc=" yt-dlp --cookies-from-browser chrome "

# 🔄 Video Joiner Tool
# Usage: vidjoin [file_prefix]
# Combines multiple MP4 files with the same prefix into a single video
# Features:
# - Interactive mode if no prefix provided
# - Safe temporary directory handling
# - Two-step ffmpeg processing for reliable output
# - Optional cleanup of source files
# - Progress feedback and debug information
# Example: vidjoin lecture_part will combine lecture_part1.mp4, lecture_part2.mp4, etc.
function vidjoin() {
    if [ "$#" -eq 0 ]; then
        read "file_prefix?Enter file prefix: "
    else
        file_prefix="$1"
    fi

    # Create a temporary working directory
    temp_dir="/tmp/vidjoin_$$"
    mkdir -p "$temp_dir"
    echo "Debug: Working in temporary directory: $temp_dir"
    
    # Create temp file list
    temp_filelist="$temp_dir/filelist.txt"
    : > "$temp_filelist"
    
    # Check for .mp4 files
    if ls ${file_prefix}*.mp4 >/dev/null 2>&1; then
        echo "Debug: Found .mp4 files - copying to temp directory..."
        for f in ${file_prefix}*.mp4; do
            if [[ -f "$f" ]]; then
                cp "$f" "$temp_dir/"
                echo "file '$(basename "$f")'" >> "$temp_filelist"
                echo "Debug: Copied $f"
            fi
        done
    else
        echo "No matching MP4 files found for ${file_prefix}"
        rm -rf "$temp_dir"
        return 1
    fi
    
    output_name="${file_prefix}.mp4"
    temp_output="$temp_dir/$output_name"
    echo "Debug: Output will be: $output_name"
    
    # Change to temp directory for processing
    pushd "$temp_dir" > /dev/null
    
    # Run ffmpeg concat if we have files
    if [[ -s "$temp_filelist" ]]; then
        # First concatenate to intermediate format
        echo "Step 1: Converting to intermediate format..."
        ffmpeg -f concat -safe 0 -i "$temp_filelist" \
               -c copy \
               -f mpegts \
               "$temp_dir/intermediate.ts"
        
        if [ $? -eq 0 ]; then
            echo "Step 2: Creating final MP4..."
            # Then convert back to MP4 with proper container
            ffmpeg -i "$temp_dir/intermediate.ts" \
                   -c copy \
                   -movflags +faststart \
                   "$output_name"
            ffmpeg_status=$?
        else
            ffmpeg_status=1
        fi
    else
        echo "Error: No files were added to the list"
        popd > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    
    # Cleanup only after successful operation
    popd > /dev/null
    if [ $ffmpeg_status -eq 0 ]; then
        # Copy the result back and verify
        cp "$temp_dir/$output_name" "./$output_name"
        if [ $? -eq 0 ] && [ -f "./$output_name" ]; then
            echo "Successfully created $output_name"
        
            echo "The following files will be deleted:"
            for f in ${file_prefix}*.mp4; do
                if [[ "$f" != "$output_name" ]]; then
                    echo "$f"
                fi
            done
                
            read -q "REPLY?Do you want to delete the original files? (y/n) "
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                for f in ${file_prefix}*.mp4; do
                    if [[ "$f" != "$output_name" ]]; then
                        rm "$f"
                    fi
                done
            fi
        else
            echo "Error: Failed to copy output file back to current directory"
            rm -rf "$temp_dir"
            return 1
        fi
    else
        echo "Error: ffmpeg failed to process files"
        rm -rf "$temp_dir"
        return 1
    fi
    
    # Cleanup only after successful operation
    rm -rf "$temp_dir"
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

# 🎵 Media and Download Tools
# YouTube download and video processing aliases

# 🔄 Bun Configuration
# Bun JavaScript runtime configuration
[ -s "/Users/russ.mckendrick/.bun/_bun" ] && source "/Users/russ.mckendrick/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

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