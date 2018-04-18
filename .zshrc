#zplug
source ~/.zplug/init.zsh
#zstyle ':prezto:module:prompt' theme 'sorin'

#zplug "b4b4r07/enhancd", use:init.sh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
#zplug "plugins/git",   from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chrissicool/zsh-256color"
zplug "zsh-users/zsh-history-substring-search"
zplug "mollifier/cd-gitroot"
zplug "supercrabtree/k"
zplug "hchbaw/opp.zsh"
#zplug "mafredri/zsh-async", from:github
# Source after compinit to enable completion
#zplug "knu/z", use:z.sh, defer:2
#zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
#zplug "modules/prompt", from:prezto
#zplug "dracula/zsh", as:theme
#zplug "yous/lime"


if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
#                     # プラグインを読み込み、コマンドにパスを通す
zplug load --verbose



#my setup
export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
alias setupATLAS='source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'
alias setRoot='setupATLAS && lsetup root'
alias rootnew='setupATLAS && lsetup "root 6.12.04-x86_64-slc6-gcc62-opt" '
#pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
zmodload zsh/complist
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^j' vi-down-line-or-history
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^l' vi-forward-char


# for autojump
#[[ -s /home/yfukuhar/.autojump/etc/profile.d/autojump.sh ]] && source /home/yfukuhar/.autojump/etc/profile.d/autojump.sh


autoload -U compinit; compinit

setopt auto_cd

alias ...='cd ../..'
alias ....='cd ../../..'
alias ls='ls -CFX --color=auto'
alias l='ls -rtl'
alias ll='ls -artl'
alias lll='ls -rtl'
alias bd='cd ../' #back directory
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
function evi(){
  evince $1 &
}
alias root='root -l'
alias v='vim'
alias vi='vim `ls -1a | peco` '
alias g='git'
alias le='less'
alias wa='watch -n 1 -d'
alias vd='cd -'
alias gitlog='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" --all'

zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

function echo_display {
  echo $DISPLAY | sed -e 's/localhost://' -e 's/\.0//'
}

#history
export HISTFILE=${HOME}/.zhistory
export HISTSIZE=100000
export SAVEHIST=100000
setopt share_history
setopt hist_ignore_all_dups
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

#
#autoload -U promptinit; promptinit

 # optionally define some options
#PURE_CMD_MAX_EXEC_TIME=10

#https://unix.stackexchange.com/questions/547/make-my-zsh-prompt-show-mode-in-vi-mode
setopt prompt_subst
#autoload -Uz vcs_info
autoload -Uz colors; colors # black red green yellow blue magenta cyan white
autoload -Uz add-zsh-hook
autoload -Uz terminfo

#zstyle ':vcs_info:git:*' check-for-changes true #formats 設定項目で %c,%u が使用可
#zstyle ':vcs_info:git:*' stagedstr "%F{242}!" #commit されていないファイルがある
#zstyle ':vcs_info:git:*' unstagedstr "%F{242}+" #add されていないファイルがある
#zstyle ':vcs_info:*' formats "%F{242}%c%u(%b)%f" #通常
#zstyle ':vcs_info:*' actionformats '[%b|%a]' #rebase 途中,merge コンフリクト等 formats 外の表示

terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
function insert-mode () { echo "-- INSERT --" }
function normal-mode () { echo "-- NORMAL --" }

precmd () {
  # yes, I actually like to have a new line, then some stuff and then 
  # the input line
  #vcs_info
  print -rP "
%{%F{74}%}❯ %~%{$reset_color%}"
  # this is required for initial prompt and a problem I had with Ctrl+C or
  # Enter when in normal mode (a new line would come up in insert mode,
  # but normal mode would be indicated)
  #local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )" 
  local ret_status="%(?:%{$fg_bold[green]%}[icepp]:%{$fg_bold[red]%}[icepp])" 
  #PS1="%{%F{242}$terminfo_down_sc$(insert-mode)$terminfo[rc]%}${vcs_info_msg_0_}$ret_status "
  #PS1="%{%F{242}$terminfo_down_sc$(insert-mode)$terminfo[rc]%}$ret_status "
  PS1="$ret_status "
}

#
function set-prompt () {
case ${KEYMAP} in
  (vicmd)      VI_MODE="$(normal-mode)" ;;
  (main|viins) VI_MODE="$(insert-mode)" ;;
  (*)          VI_MODE="$(insert-mode)" ;;
  esac
  #local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )" 
  local ret_status="%(?:%{$fg_bold[green]%}[icepp]:%{$fg_bold[red]%}[icepp])" 
  #PS1="%{%F{242}$terminfo_down_sc$VI_MODE$terminfo[rc]%}$ret_status "
  PS1="$ret_status "
}

function zle-line-init zle-keymap-select {
set-prompt
zle reset-prompt
}
preexec () { print -rn -- $terminfo[el]; }

zle -N zle-line-init
zle -N zle-keymap-select
#fin

#function zle-line-init zle-keymap-select zle-line-finish
#{
#case $KEYMAP in
#  main|viins)
#    precmd () { 
#      print
#      vcs_info
#    }
#    VIM_INSERT="%K{075}%F{black}%k%f%K{075}%F{white}% INS%k%f%K{black}%F{075}%k%f"
#    PROMPT_2="$VIM_INSERT"
#    # プロンプト（左）
#    #PROMPT=$PROMPT'%(?.%F{magenta}.%F{red})${PURE_PROMPT_SYMBOL:-❯→}%f ${vcs_info_msg_0_} %{${fg[red]}%}%}$%{${reset_color}%} '
#    ;;
#  vicmd)
#    precmd () { 
#      print
#      vcs_info
#    }
#    VIM_NORMAL="%K{208}%F{black}%k%f%K{208}%F{white}% NOR%k%f%K{black}%F{208}%k%f"
#    PROMPT_2="$VIM_NORMAL"
#    # プロンプト（左）
#    #PROMPT=$PROMPT'%(?.%F{magenta}.%F{red})${PURE_PROMPT_SYMBOL:-❯→}%f ${vcs_info_msg_0_} %{${fg[red]}%}%}$%{${reset_color}%} '
#    ;;
#esac
##PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}[%(?.%{${fg[green]}%}.%{${fg[red]}%})%n%{${reset_color}%}]%# "
#local ret_status="%(?:%{$fg_bold[green]%}❯➜ :%{$fg_bold[red]%}❯➜ )" 
#PROMPT="%{$fg[cyan]%}%~%{$reset_color%}
#$ret_status ${vcs_info_msg_0_} %{${fg[red]}%}%{${reset_color}%} "
##PROMPT="%{$fg[cyan]%}%~%{$reset_color%}
##%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}$ret_status ${vcs_info_msg_0_} %{${fg[red]}%}%}$%{${reset_color}%}%# "
#zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-line-finish
#zle -N zle-keymap-select
#zle -N edit-command-line

RPROMPT='%{%F{105}%}[%D|%T] [$(echo_display)]%{${reset_color}%}'

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'



#peco
function peco-history-selection() {
BUFFER=`history -n 1 | tac -r  | awk '!a[$0]++' | peco`
CURSOR=$#BUFFER
zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

##　ユーザーディレクトリ内にインストールした場合はPATHを設定
PATH=$PATH:~/local/peco_linux_amd64/
export PATH=$PATH:~/local/peco_linux_amd64/
#export HOME=/gpfs/home/yfukuhar/

function peco_select(){
  $1 `ls -1a | peco` 
}
alias pe=peco_select

#function find_cd() {
#cd "$(find . -maxdepth 3 -type d | grep -v "\/\." | peco)"  
#}
#alias fc="find_cd"

#history
#HISTORY_IGNORE="(ls*|cd*|pwd*|exit|bd*|fg*|vd*|ll*|)"
zshaddhistory() {
  local line=${1%%$'\n'}
  local cmd=${line%% *}

  # 以下の条件をすべて満たすものだけをヒストリに追加する
  [[ ${#line} -ge 5
  && ${cmd} != (l|l[sal])
  && ${cmd} != (c|cd)
  && ${cmd} != (m|man)
  && ${cmd} != (pwd)
  && ${cmd} != (bd)
  && ${cmd} != (rm)
  && ${cmd} != (mv)
  && ${cmd} != (cp)
  && ${cmd} != (mkdir)
  ]]
}
export LS_COLORS='di=04;035'

#export LS_COLORS='di=35'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# tmux buffer paste
function peco-select-tmux-history() {
local buffer_list=$(tmux list-buffer | peco | cut -f1 -d: | xargs tmux paste-buffer -b)
if [ -n "$buffer_list" ]; then
  BUFFER="$buffer_list"
fi
zle clear-screen
}
zle -N peco-select-tmux-history
bindkey '^y' peco-select-tmux-history

#if [ "$SSH_TTY" != "" ]; then
#  source $HOME/.enhancd/enhancd/init.sh
#fi

bindkey '^f' autosuggest-accept

bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down


bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
##z
#function peco-z-search
#{
#  which peco z > /dev/null
#  if [ $? -ne 0 ]; then
#    echo "Please install peco and z"
#    return 1
#  fi
#  local res=$(z | sort -rn | cut -c 12- | peco)
#  if [ -n "$res" ]; then
#    BUFFER+="cd $res"
#    zle accept-line
#  else
#    return 1
#  fi
#}
#zle -N peco-z-search
#bindkey '^f' peco-z-search

#
# Aliases
# (sorted alphabetically)
#

alias g='git'

alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'
alias gap='git apply'

alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbda='git branch --no-color --merged | command grep -vE "^(\*|\s*(master|develop|dev)\s*$)" | command xargs -n 1 git branch -d'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gcn!='git commit -v --no-edit --amend'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcan!='git commit -v -a --no-edit --amend'
alias gcans!='git commit -v -a -s --no-edit --amend'
alias gcam='git commit -a -m'
alias gcsm='git commit -s -m'
alias gcb='git checkout -b'
alias gcf='git config --list'
alias gcl='git clone --recursive'
alias gclean='git clean -fd'
alias gpristine='git reset --hard && git clean -dfx'
alias gcm='git checkout master'
alias gcd='git checkout develop'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcs='git commit -S'

alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gdct='git describe --tags `git rev-list --tags --max-count=1`'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'

alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'

function gfg() { git ls-files | grep $@ }

alias gg='git gui citool'
alias gga='git gui citool --amend'

alias ggpur='ggu'
compdef _git ggpur=git-checkout

alias ggpull='git pull origin $(git_current_branch)'
compdef _git ggpull=git-checkout

alias ggpush='git push origin $(git_current_branch)'
compdef _git ggpush=git-checkout

alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias gpsup='git push --set-upstream origin $(git_current_branch)'

alias ghh='git help'

alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef _git git-svn-dcommit-push=git

alias gk='\gitk --all --branches'
compdef _git gk='gitk'
alias gke='\gitk --all $(git log -g --pretty=%h)'
compdef _git gke='gitk'

alias gl='git pull'
alias glg='git log --stat'
alias glgp='git log --stat -p'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glp="_git_log_prettily"
compdef _git glp=git-log

alias gm='git merge'
alias gmom='git merge origin/master'
alias gmt='git mergetool --no-prompt'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/master'
alias gma='git merge --abort'

alias gp='git push'
alias gpd='git push --dry-run'
alias gpoat='git push origin --all && git push origin --tags'
compdef _git gpoat=git-push
alias gpu='git push upstream'
alias gpv='git push -v'

alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase master'
alias grbs='git rebase --skip'
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote -v'

alias gsb='git status -sb'
alias gsd='git svn dcommit'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gss='git status -s'
alias gst='git status'
alias gsta='git stash save'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gsu='git submodule update'

alias gts='git tag -s'
alias gtv='git tag | sort -V'

alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gupv='git pull --rebase -v'
alias glum='git pull upstream master'


tty -s && stty stop undef
tty -s && stty start undef

alias -g L='| less'
alias -g G='| grep'

# for tmux 2.7
export LD_LIBRARY_PATH=${HOME}/local/lib:$LD_LIBRARY_PATH
alias tmux='$HOME/local/bin/tmux'

