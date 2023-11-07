# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/russ.mckendrick/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(git ansible docker macos terraform vscode gh)
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

if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

if command -v thefuck 1>/dev/null 2>&1; then
  eval $(thefuck --alias)
fi

alias python=/usr/bin/python3

### Aliases
alias s='open -a "Sublime Text"'
alias v='code '

# Run SSH Add for the session
if [ -f ~/.ssh/id_rsa ]; then
  ssh-add -K ~/.ssh/id_rsa 2>/dev/null
fi

alias dlc=" yt-dlp --cookies-from-browser chrome " # downloads

# Hugo
alias blog="cd ~/Code/blog/ && hugo server --buildDrafts"
alias eblog="code ~/Code/blog/"

# add an alias for drawio
alias draw.io='/Applications/draw.io.app/Contents/MacOS/draw.io'

# add an alias for pip adding the user flag !!!
alias pii="python -m pip3 install --user "

# add an alias for some common terraform tasks
alias tfrm="rm -rf .terraform *.tfstate*"
alias tfi="terraform init"
alias tfa="terraform apply -auto-approve"
alias tfd="terraform destroy"

# add some init lines
function initans { mkdir "$1" "$1/group_vars" "$1/roles" "$1/inv" && touch "$1/group_vars/common.yml" "$1/inv/production" "$1/README.md" "$1/site.yml" "$1/Vagrantfile" "$1/.gitignore" "$1/roles/.gitkeep" && echo "*.retry \ngroup_vars/dyn*" >"$1/.gitignore" && echo "# $1" >"$1/README.md" && code "$1"; }
alias initter=""

# alias to jump around work servers, work from a work machine and home from home :)
alias home="ssh -i ~/.ssh/id_rsa.work -A -t russ.mckendrick@10.2.5.125 ssh -A -t "
alias work="ssh -A -t russ.mckendrick@10.2.5.125 ssh -A -t "
alias proxy="ssh -D 8888 russ.mckendrick@10.2.5.125"
alias sshm="ssh -A -t russ.mckendrick@10.200.106.34 ssh -A -t "
alias sshmhome="ssh -i ~/.ssh/id_rsa.work -A -t russ.mckendrick@10.200.106.34 ssh -A -t "

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
alias cod="cd ~/Documents/Code/"
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

# Fix an issue with pyton bombing out when using WinRM
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# eval "$(starship init zsh)"

# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
#         . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<

# init z! (https://github.com/rupa/z)
. ~/.dotfiles/z.sh
