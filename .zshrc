if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/russ.mckendrick/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git ansible docker macos terraform vscode gh brew)
source $ZSH/oh-my-zsh.sh
DEFAULT_USER=$(whoami)

# Some defaults and paths
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

# init the fuck!!! (https://github.com/nvbn/thefuck)
if command -v thefuck 1>/dev/null 2>&1; then
  eval $(thefuck --alias)
fi

# init zoxide (https://github.com/ajeetdsouza/zoxide)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# Aliases

# IDEs
alias s='open -a "Sublime Text"'
alias v='code '

# Python
alias pip='python -m pip'

# Run SSH Add for the session
if [ -f ~/.ssh/id_rsa ]; then
  ssh-add -K ~/.ssh/id_rsa 2>/dev/null
fi

# Hugo
alias blog="cd ~/Code/blog/ && hugo server --buildDrafts --buildFuture"
alias bloge="code ~/Code/blog/"
alias blogimg='for file in *; do [[ -f "$file" && ! -f "${file%.*}.meta" ]] && echo "{\n\"Title\": \"${file%.*}\"\n}" > "${file}.meta"; done'

# Add an alias and bits for some common ansible tasks
alias al='ansible-lint -c ~/.config/ansible-lint.yml'
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Add an alias and bits for some common terraform tasks
alias tfrm="rm -rf .terraform *.tfstate*"
alias tfi="terraform init"
alias tfa="terraform apply -auto-approve"
alias tfd="terraform destroy"

# Color LS
colorflag="-G"
alias ls="command ls ${colorflag}"
alias l="ls -lF ${colorflag}"               # all files, in long format
alias la="ls -laF ${colorflag}"             # all files inc dotfiles, in long format
alias lsd='ls -lF ${colorflag} | grep "^d"' # only directories
alias lr="ls -ltr ${colorflag}"
alias lra="ls -ltrA ${colorflag}"

# Quicker navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias tree="tree -I '.git'"

# Shortcuts to my Code folder in my home directory
alias cod="cd ~/Code/"
alias dt="cd ~/.dotfiles/"

# Enable aliases to be sudo’ed
alias sudo='sudo '
alias hoste='sudo code /private/etc/hosts'
alias flush='sudo killall -HUP mDNSResponder; sleep 2;'

# Colored up cat!
# You must install Pygments first - "sudo easy_install Pygments"
alias c='pygmentize -O style=monokai -f console256 -g'

# Git aliases
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m' # requires you to type a commit message
alias gp='git push'
alias gpu='git pull'

# add an alias for drawio
alias draw.io='/Applications/draw.io.app/Contents/MacOS/draw.io'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.dotfiles/.p10k.zsh ]] || source ~/.dotfiles/.p10k.zsh

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

# Conda Select function with colors and styling
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

# Function to generate my discogs collection
function scrape() {
    cd ~/Code/discogs/
    conda activate discogs
    python discogs_scraper.py --all --delay=0
    conda deactivate
}

# Downloads and video stuff
alias dlc=" yt-dlp --cookies-from-browser chrome "

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
    
    # First check for .ts files
    if ls ${file_prefix}*.ts >/dev/null 2>&1; then
        echo "Debug: Found .ts files - copying to temp directory..."
        for f in ${file_prefix}*.ts; do
            if [[ -f "$f" ]]; then
                cp "$f" "$temp_dir/"
                echo "file '$(basename "$f")'" >> "$temp_filelist"
                echo "Debug: Copied $f"
            fi
        done
        output_ext="ts"
    # Then check for .mp4 files if no .ts files found
    elif ls ${file_prefix}*.mp4 >/dev/null 2>&1; then
        echo "Debug: Found .mp4 files - copying to temp directory..."
        for f in ${file_prefix}*.mp4; do
            if [[ -f "$f" ]]; then
                cp "$f" "$temp_dir/"
                echo "file '$(basename "$f")'" >> "$temp_filelist"
                echo "Debug: Copied $f"
            fi
        done
        output_ext="mp4"
    else
        echo "No matching files found for ${file_prefix}"
        rm -rf "$temp_dir"
        return 1
    fi
    
    output_name="${file_prefix}.${output_ext}"
    temp_output="$temp_dir/$output_name"
    echo "Debug: Output will be: $output_name"
    
    # Change to temp directory for processing
    pushd "$temp_dir" > /dev/null
    
    # Run ffmpeg concat if we have files
    if [[ -s "$temp_filelist" ]]; then
        ffmpeg -f concat -safe 0 -i "$temp_filelist" -c copy "$output_name"
        ffmpeg_status=$?
        popd > /dev/null
        
        if [ $ffmpeg_status -eq 0 ]; then
            # Copy the result back and verify
            cp "$temp_dir/$output_name" "./$output_name"
            if [ $? -eq 0 ] && [ -f "./$output_name" ]; then
                echo "Successfully created $output_name"
            
                echo "The following files will be deleted:"
                for f in ${file_prefix}*.${output_ext}; do
                    if [[ "$f" != "$output_name" ]]; then
                        echo "$f"
                    fi
                done
                
                read -q "REPLY?Do you want to delete the original files? (y/n) "
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    for f in ${file_prefix}*.${output_ext}; do
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
    else
        echo "Error: No files were added to the list"
        popd > /dev/null
        rm -rf "$temp_dir"
        return 1
    fi
    
    # Cleanup only after successful operation
    rm -rf "$temp_dir"
}

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

# bun completions
[ -s "/Users/russ.mckendrick/.bun/_bun" ] && source "/Users/russ.mckendrick/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Ignore VS Code related Python commands and vidjoin commands
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
# Added by Windsurf
export PATH="/Users/russ.mckendrick/.codeium/windsurf/bin:$PATH"
