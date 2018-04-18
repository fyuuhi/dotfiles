# .bashrc

## Source global definitions
#if [ -f /etc/bashrc ]; then
#	. /etc/bashrc
#fi
#
if [ "$SSH_TTY" != "" ]; then
  echo "------------------------"
  echo "Applying zsh settings..."
  echo "------------------------"
  echo $DISPLAY
  #export HOME=/gpfs/home/yfukuhar/
  export SHELL=/bin/zsh
  exec $SHELL -l
fi

if [ -f ~/.git-completion.bash ]; then
  source ~/.git-comletion.bash
fi

if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

# User specific aliases and functions
#PS1="\[\e[1;33m\\][\D{%Y/%m/%d}|\t@\w]\n\[\e[0m\]\[\e[1;31m\][icepp]\[\e[0m\]" 
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function echo_display {
  echo $DISPLAY | sed -e 's/localhost://' -e 's/\.0//'
}


function git_or_icepp {
#branch_name=`git branch | grep \*.* | sed -e 's/\*\ //'`

[ ! -z $(parse_git_branch) ] && echo "$(parse_git_branch)"

[ -z $(parse_git_branch) ] && echo "icepp"

}


function promps {
  local  BLUE="\[\e[1;34m\]"
  local  RED="\[\e[1;31m\]"
  local  GREEN="\[\e[1;32m\]"
  local  WHITE="\[\e[00m\]"
  local  GRAY="\[\e[1;37m\]"
  local  CYAN="\[\e[1;36m\]"
  local  MAGENTA="\[\e[1;35m\]"
  local  YELLOW="\[\e[1;33m\]"


  #PS1="${WHITE}[${GREEN}\D{%Y/%m/%d}${WHITE}|${YELLOW}\t${GRAY}|${BLUE}\w${WHITE}]\n${RED}[\$(echo_display):\$(git_or_icepp)]${WHITE}" 
  PS1="${WHITE}[${GREEN}\D{%Y/%m/%d}${WHITE}|${YELLOW}\t${GRAY}|${BLUE}\w${WHITE}]\n${RED}[\$(echo_display):\$(__git_ps1)]${WHITE}" 
  #PS1="${TITLEBAR}${GREEN}${BASE}${WHITE}:${BLUE}\W${GREEN}\$(parse_git_branch)${BLUE}\$${WHITE} "
}

promps


function evi(){
  evince $1 &
}




export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
alias setupATLAS='source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'
alias rootnew='lsetup "root 6.12.04-x86_64-slc6-gcc62-opt" '

alias gl='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'

alias ls='ls -CFX --color=auto'
alias ll='ls -artl'
alias lll='ls -rtl'
alias bd='cd ../' #back directory
#alias rm='mv -i ~/Trash/'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
#alias evi='evince'
alias root='root -l'
alias v='vim'
alias g='git'
alias le='less'
alias wa='watch -n 1 -d'
alias vd='cd -'

export LS_COLORS='di=01;35'


#share_history for tmux
function share_history {
    history -a
    history -c
    history -r
}
PROMPT_COMMAND='share_history'
shopt -u histappend


export HISTIGNORE="fg*:bg*:history*:cd*:ls*:pwd*"

export HISTSIZE=50000

#keybind
set -o vi
bind '"jj": vi-movement-mode'

tty -s && stty stop undef
tty -s && stty start undef

#if [ $PS1 ]; then
#fi

#cal -3

