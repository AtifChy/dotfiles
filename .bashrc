#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash/history"


# bash settings
shopt -s autocd
shopt -s checkwinsize

# aliases
alias dot="git --git-dir=$XDG_DATA_HOME/dotfiles --work-dir=$HOME"

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -alh --group-directories-first'
alias l='ls -CF'

alias grep='grep --color=auto'

#prompt
PS1='[\u@\h \W]\$ '

# command not found handler
source /usr/share/doc/pkgfile/command-not-found.bash
