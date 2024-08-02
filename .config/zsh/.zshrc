####################################################
## load these at the beginning
####################################################

# enable powerlevel10k instant prompt. should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# set emacs keybinding
bindkey -e

####################################################
## zgenom initialization
####################################################

# enable extended globbing
setopt extendedglob

# if any of these files are modified, re-save zgenom
ZGEN_RESET_ON_CHANGE=(${ZDOTDIR}/**/^*.(zwc|bak)(D.N))

# load zgenom
ZGEN_SOURCE="${XDG_DATA_HOME:-$HOME/.local/share}/zgenom"
if [[ ! -d $ZGEN_SOURCE ]]; then
  print -P "%B%F{yellow}warn:%f%b zgenom not found."
  print -P "%B%F{blue}info:%f%b Installing zgenom..."
  command git clone https://github.com/jandamm/zgenom.git "$ZGEN_SOURCE" && \
    print -P "%B%F{green}done:%f%b zgenom installed." || \
    print -P "%B%F{red}error%f%b: cloning failed."
fi

source "$ZGEN_SOURCE/zgenom.zsh"

# check for plugin and zgenom updates every 7 days
# this does not increase the startup time.
zgenom autoupdate

if ! zgenom saved; then
  ## extensions
  zgenom load jandamm/zgenom-ext-eval

  ## prompt
  zgenom load romkatv/powerlevel10k powerlevel10k

  ## plugins
  zgenom load zsh-users/zsh-history-substring-search
  zgenom eval --name history-substring-search-init <<EOF
bindkey '^[[A' history-substring-search-up      # up
bindkey '^[[B' history-substring-search-down    # down
EOF

  zgenom load zsh-users/zsh-completions
  zgenom load MichaelAquilina/zsh-you-should-use zsh-you-should-use.plugin.zsh

  zgenom load hlissner/zsh-autopair zsh-autopair.plugin.zsh
  zgenom eval --name autopair-init <<EOF
bindkey '^H' autopair-delete-word               # ctrl-backspace
EOF

  # local plugins
  zgenom load "$ZDOTDIR/plugins"

  # create zoxide initialization file
  zgenom eval --name zoxide < <(zoxide init zsh)

  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-syntax-highlighting

  ## save all to init script
  zgenom save

  ## compile zsh files
  zgenom compile "$ZGEN_RESET_ON_CHANGE"

  # something is messing with the cursor, so reset it
  tput cnorm
fi

####################################################
## end of zgenom initialization
####################################################

####################################################
## plugin configuration
####################################################

## zsh-history-substring-search config
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=0,fg=12,underline'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=0,fg=9,underline'
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true

## zsh-autosuggestions config
ZSH_AUTOSUGGEST_MANUAL_REBIND=true
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_COMPLETION_IGNORE='_*|pre(cmd|exec)|man*|^*.(dll|exe)'
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(autopair-insert backward-delete-char)

## zsh-syntax-highlighting config
ZSH_HIGHLIGHT_HIGHLIGHTERS=(regexp main brackets cursor)

ZSH_HIGHLIGHT_STYLES[path]='fg=magenta,underline'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[cursor]=none
ZSH_HIGHLIGHT_STYLES[redirection]='fg=blue'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=blue'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=yellow'

# highlight variables
ZSH_HIGHLIGHT_REGEXP+=('\$([[:alnum:]_-]+|\{[[:alnum:]_-]+\})' 'fg=cyan')
#ZSH_HIGHLIGHT_REGEXP+=('\$(\w+|\{[[:alnum:]]+(\[[[:alnum:]]+\]*)?\})' 'fg=cyan')

## zsh-you-should-use config
YSU_MESSAGE_POSITION=after
YSU_MESSAGE_FORMAT='\e[34;1m[tip]\e[0m \e[1m%alias\e[0m => %command'
YSU_IGNORED_ALIASES=(':q' ':x')

####################################################
## end of plugin configuration
####################################################

####################################################
## zsh settings
####################################################

# general settings
setopt autocd                               # change to directory without cd
setopt interactivecomments                  # allow comments in interactive shell
setopt automenu                             # show completion menu on a successive tab press
setopt nobeep                               # disable beeping on tab completion
setopt completeinword                       # allow completion from both ends
setopt alwaystoend                          # move cursor to end of completion

# history settings
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/zsh_history"
[[ ! -d ${HISTFILE:h} ]] && mkdir -p "${HISTFILE:h}"
HISTSIZE=50000
SAVEHIST=10000

setopt extendedhistory                      # save timestamp and duration of command
setopt histignoredups                       # ignore duplicate commands
setopt histignorespace                      # ignore commands starting with space
setopt histreduceblanks                     # remove leading and trailing blanks
setopt histexpiredupsfirst                  # remove duplicates first when history is full
setopt histverify                           # verify history expansion
setopt sharehistory                         # share history between sessions
setopt incappendhistory                     # append new history to history file

# set LS_COLORS
source <(dircolors)

# completion config
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' complete-options true
zstyle ':completion:*' insert-tab false
zstyle ':completion:*' list-separator '->'
zstyle ':completion:*:default' list-colors '=(#b)*(-> *)==33;3' ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*:default' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:corrections' format '%B%%F{yellow}!-> %d (error: %e) <-!%f%b'
zstyle ':completion:*:descriptions' format '%B%F{cyan}--> %d <--%f%b'
zstyle ':completion:*:warnings' format '%B%F{red}--> no match found <--%f%b'
zstyle ':completion:*:messages' format '%B%F{yellow}--> %d <--%f%B'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*:(vim|nvim|vi|nano):*' ignored-patterns '*.(wav|mp3|flac|ogg|mp4|avi|mkv|iso|so|o|7z|zip|tar|gz|bz2|rar|deb|pkg|gzip|pdf|png|jpeg|jpg|gif|zwc)'
zstyle ':completion:*:matches' group yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
zstyle ':completion:*' list-dirs-first true

# on-demand rehash using SIGUSR1
# NOTE requires pacman hook to be installed
# https://wiki.archlinux.org/title/Zsh#Alternative_on-demand_rehash_using_SIGUSR1
trap 'rehash' USR1

# auto quote problematic urls
autoload -Uz bracketed-paste-url-magic
zle -N bracketed-paste bracketed-paste-url-magic

# disable highlight of pasted text
zle_highlight+=(paste:none)

# prompt used in multiline commands
PROMPT2="%8F·%f "

# change zsh eol character
[[ $TERM == 'linux' ]] || PROMPT_EOL_MARK='%F{8}󰘌%f'

# a list of non-alphanum chars considered part of a word by the line editor.
# zsh's default is "*?_-.[]~=/&;!#$%^(){}<>"
WORDCHAR='@_'

# generate completion from `--help`
compdef _gnu_generic fzf

# load other config files
for config in ${ZDOTDIR}/configs/*.zsh; do
  source $config
done

####################################################
## end of zsh settings
####################################################

####################################################
## aliases
####################################################

alias ls="${${commands[eza]:t}:-ls} --color=auto --group-directories-first"
alias la='ls -a'
alias l='ls -lh'
alias ll='ls -alh'
alias lr='ls -R'
alias lR='ls -alRh'

alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -Iv'
alias ln='ln -iv'
alias rd='rmdir -v'
alias mkdir='mkdir -pv'

alias chown='chown -v --preserve-root'
alias chmod='chmod -v --preserve-root'
alias chgrp='chgrp -v --preserve-root'

alias grep='grep --color=auto'
alias egrep='grep -E'
alias fgrep='grep -F'

alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias ping='ping -c 5 -W 30'
alias watch='watch --color'
alias df='df -h'
alias du='du -ch'
alias dmesg='dmesg -H'
alias free='free -h'
alias cat='bat --style=plain --paging=never'

alias reload='exec zsh'
alias :q='exit'
alias :x='exit'

alias dot="git --git-dir=${XDG_DATA_HOME}/dotfiles --work-tree=${HOME}"

# abbreviations
if declare -f abbr &>/dev/null; then
  abbr ..='cd ..'
  abbr ...='cd ../..'
  abbr ....='cd ../../..'
  abbr .....='cd ../../../..'

  abbr ff=fastfetch
  abbr v=nvim
  abbr sv=sudoedit
  abbr zg=zgenom
fi

####################################################
## end of aliases
####################################################

####################################################
## keybinding
####################################################

bindkey '^[[H' beginning-of-line                    # home
bindkey '^[[F' end-of-line                          # end
bindkey '^[[2~' overwrite-mode                      # insert
bindkey '^[[3~' delete-char                         # delete
bindkey '^[[3;5~' delete-word                       # ctrl-delete
bindkey '^[[D' backward-char                        # left
bindkey '^[[C' forward-char                         # right
bindkey '^[[1;5D' backward-word                     # ctrl-left
bindkey '^[[1;5C' forward-word                      # ctrl-right
bindkey '^[[1;3D' backward-word                     # alt-left
bindkey '^[[1;3C' forward-word                      # alt-right
bindkey '^[[5~' beginning-of-buffer-or-history      # pageup
bindkey '^[[6~' end-of-buffer-or-history            # pagedown
bindkey '^[[Z' reverse-menu-complete                # shift-tab
bindkey '^Z' undo                                   # ctrl-z
bindkey '^_' redo                                   # ctrl-/
bindkey '^[' kill-line                              # esc

# bindkey '^?' backward-delete-char                 # backspace
# bindkey '^H' backward-delete-word                 # ctrl-backspace
# bindkey '^R' history-incremental-search-backward  # ctrl-r
# bindkey '^K' kill-line                            # ctrl-k

# enable searching in menu selection
zmodload zsh/complist
bindkey -M menuselect -- '?' history-incremental-search-forward
bindkey -M menuselect -- '/' history-incremental-search-backward

# make switching between insert and normal mode faster
KEYTIMEOUT=10

####################################################
## end of keybinding
####################################################

####################################################
## misc
####################################################

# To customize prompt, run `p10k configure` or edit $ZDOTDIR/.p10k.zsh.
[[ -f ${ZDOTDIR}/p10k.zsh ]] && source "$ZDOTDIR/p10k.zsh"
