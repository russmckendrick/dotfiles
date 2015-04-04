### Aliases

# Open specified files in Sublime Text 2
# "s ." will open the current directory in Sublime
alias s='open -a "Sublime Text 2"'

# Open specified files in Marked 2
alias m='open -a "Marked 2"'

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
alias tree="tree -Csuha -I '.git'"

# Shortcuts to my Code folder in my home directory
alias code="cd ~/Documents/Code/"
alias blog="cd ~/Documents/Code/russmckendrick.github.io"

# Run Jekyll with the _config-dev.yml file
alias jb='jekyll serve -w -c _config-dev.yml'

# Enable aliases to be sudo’ed
alias sudo='sudo '
alias hoste='sudo open -a "Sublime Text 2" /private/etc/hosts'

# Colored up cat!
# You must install Pygments first - "sudo easy_install Pygments"
alias c='pygmentize -O style=monokai -f console256 -g'

# Git
# You must install Git first - ""
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m' # requires you to type a commit message
alias gp='git push'
alias gpu='git pull'

# Docker alias and function
alias dl="docker ps -l -q"
alias dps="docker ps"
alias dpa="docker ps -a"
alias di="docker images"
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias dkd="docker run -d -P"
alias dki="docker run -i -t -P"

# Boot2Docker
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/russ/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1

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
		BLACK=$(tput setaf 190)
		MAGENTA=$(tput setaf 9)
		ORANGE=$(tput setaf 172)
		GREEN=$(tput setaf 190)
		PURPLE=$(tput setaf 141)
		WHITE=$(tput setaf 0)
	else
		BLACK=$(tput setaf 190)
		MAGENTA=$(tput setaf 5)
		ORANGE=$(tput setaf 4)
		GREEN=$(tput setaf 2)
		PURPLE=$(tput setaf 1)
		WHITE=$(tput setaf 7)
	fi
	BOLD=$(tput bold)
	RESET=$(tput sgr0)
else
	BLACK="\033[01;30m"
	MAGENTA="\033[1;31m"
	ORANGE="\033[1;33m"
	GREEN="\033[1;32m"
	PURPLE="\033[1;35m"
	WHITE="\033[1;37m"
	BOLD=""
	RESET="\033[m"
fi

export BLACK
export MAGENTA
export ORANGE
export GREEN
export PURPLE
export WHITE
export BOLD
export RESET

# Git branch details
function parse_git_dirty() {
	[[ $(git status 2> /dev/null | tail -n1) != *"working directory clean"* ]] && echo "*"
}
function parse_git_branch() {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# Change this symbol to something sweet.
# (http://en.wikipedia.org/wiki/Unicode_symbols)
symbol="⚡  "

export PS1="\[${BOLD}${MAGENTA}\]\u @ \h \[$WHITE\]in \[$GREEN\]\w\[$WHITE\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$PURPLE\]\$(parse_git_branch)\[$WHITE\]\n$symbol\[$RESET\]"
export PS2="\[$ORANGE\]→ \[$RESET\]"


### Misc

# Only show the current directory's name in the tab
export PROMPT_COMMAND='echo -ne "\033]0;${PWD##*/}\007"'

# init z! (https://github.com/rupa/z)
. ~/.z.sh
export PATH=/usr/local/bin:~/.local/lib/aws/bin:$PATH
export PATH=$PATH:/usr/local/go/bin

# Add the right path for Cask
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# CLI Proxy Proxy Settings
# (This sets various proxy settings on the commandline based on which location I have enabled)

   if [ -f "/usr/sbin/scselect" ]; then
      export LOCATION=$(/usr/sbin/scselect 2>&1 | perl -ne 'if (m/^\s+\*\s+(\S+)\s+\((.+)\)$/) { print "$2\n"; }')
   fi

   # Location-specific settings

   if [ ! -z "$LOCATION" -a "$LOCATION" = "Work" ]; then
      export ALL_PROXY="http://10.0.0.2:3128"
      export npm_config_proxy="http://10.0.0.2:3128"
	  export npm_config_https_proxy="http://10.0.0.2:3128"
   else
      unset http_proxy
      unset npm_config_proxy
      unset npm_config_https_proxy
   fi

