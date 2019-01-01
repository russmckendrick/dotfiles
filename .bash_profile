### Aliases

# Open specified files in Sublime Text or Atom
# "s ." will open the current directory in Sublime
alias s='open -a "Sublime Text"'
alias v='open -a "Sublime Text"'
alias a='open -a "Sublime Text"'

# Run SSH Add for the session
if [ -f ~/.ssh/id_rsa ]; then
    ssh-add -K ~/.ssh/id_rsa 2>/dev/null
fi

# add an alias for pip adding the user flag !!!
alias pii="pip install --user "

alias awss="switcher "

# alias to jump around work servers, work from a work machine and home from home :)
alias home="ssh -i ~/.ssh/russ-work -A -t russ.mckendrick@10.2.5.125 ssh -A -t "
alias work="ssh -A -t russ.mckendrick@10.2.5.125 ssh -A -t "

# Color LS
colorflag="-G"
alias ls="command ls ${colorflag}"
alias l="ls -lF ${colorflag}" # all files, in long format
alias la="ls -laF ${colorflag}" # all files inc dotfiles, in long format
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
alias hoste='sudo atom /private/etc/hosts'

# Colored up cat!
# You must install Pygments first - "sudo easy_install Pygments"
alias c='pygmentize -O style=monokai -f console256 -g'

# Git aliases
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m' # requires you to type a commit message
alias gp='git push'
alias gpu='git pull'

# Docker alias and function
# alias dl="docker ps -l -q"
# alias dps="docker ps"
# alias dpa="docker ps -a"
# alias di="docker images"
# alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
# alias dkd="docker run -d -P"
# alias dki="docker run -i -t -P"
# alias drmi="docker rmi $(docker images -q)"
# alias drmc="docker rm $(docker ps -a -q)"

# Some defaults and paths
export PATH=/usr/local/bin:~/.local/lib/aws/bin:/usr/local/sbin:~/Library/Python/2.7/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export ANSIBLE_SSH_CONTROL_PATH='/tmp/%%h-%%p-%%r'
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_LOG_PATH="/var/log/ansible.log"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Fix an issue with pyton bombing out when using WinRM
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

#
# Everything below here can be imported from https://github.com/barryclark/bashstrap/blob/master/.bash_profile
#

### Prompt Colors
# Modified version of @gf3’s Sexy Bash Prompt
# (https://github.com/gf3/dotfiles)
if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM=xterm-256color
fi

if tput setaf 1 &> /dev/null; then
	tput sgr0
	if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
		MAGENTA=$(tput setaf 9)
		ORANGE=$(tput setaf 172)
		GREEN=$(tput setaf 190)
		PURPLE=$(tput setaf 141)
	else
		MAGENTA=$(tput setaf 5)
		ORANGE=$(tput setaf 4)
		GREEN=$(tput setaf 2)
		PURPLE=$(tput setaf 1)
	fi
	BOLD=$(tput bold)
	RESET=$(tput sgr0)
else
	MAGENTA="\033[1;31m"
	ORANGE="\033[1;33m"
	GREEN="\033[1;32m"
	PURPLE="\033[1;35m"
	BOLD=""
	RESET="\033[m"
fi

export MAGENTA
export ORANGE
export GREEN
export PURPLE
export BOLD
export RESET

# Git branch details
function parse_git_dirty() {
	[[ $(git status 2> /dev/null | tail -n1) != *"working tree clean"* ]] && echo "*"
}
function parse_git_branch() {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# Change this symbol to something sweet.
# (http://en.wikipedia.org/wiki/Unicode_symbols)
symbol="⚡  "

export PS1="\[${MAGENTA}\]\u \[$RESET\]in \[$GREEN\]\w\[$RESET\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$PURPLE\]\$(parse_git_branch)\[$RESET\]\n$symbol\[$RESET\]"
export PS2="\[$ORANGE\]→ \[$RESET\]"

### Misc

# Only show the current directory's name in the tab
export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'

# init z! (https://github.com/rupa/z)
. ~/.dotfiles/z.sh