#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash/history"

alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -alh --group-directories-first'
alias l='ls -CF'

alias grep='grep --color=auto'


PS1='[\u@\h \W]\$ '
