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
setopt extended_glob

# if any of these files are modified, re-save zgenom
ZGEN_RESET_ON_CHANGE=( ${ZDOTDIR}/**/^*.(zwc|bak)(D.N) )

# disable extended globbing
unsetopt extended_glob

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
  # prompt
  zgenom load romkatv/powerlevel10k powerlevel10k

  # plugins
  zgenom load zsh-users/zsh-history-substring-search
  zgenom load zsh-users/zsh-completions
  zgenom load MichaelAquilina/zsh-you-should-use
  zgenom load hlissner/zsh-autopair
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-syntax-highlighting

  # save all to init script
  zgenom save

  # compile zsh files
  zgenom compile $ZGEN_RESET_ON_CHANGE
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
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=10
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
ZSH_HIGHLIGHT_REGEXP+=('\$(\w+|\{.*\})' 'fg=cyan')
ZSH_HIGHLIGHT_REGEXP+=('\[.*\]' 'fg=white')

## zsh-you-should-use config
YSU_MESSAGE_POSITION=after
YSU_MESSAGE_FORMAT='\e[34;1m[tip]\e[0m \e[1m%alias\e[0m => %command'
YSU_IGNORED_ALIASES=(':q' ':x')

####################################################
## end of plugin configuration
####################################################

####################################################
## custom plugins
####################################################

# load abbr, title, osc, command-not-found
for plugin in ${ZDOTDIR}/plugins/*.zsh; do
  source $plugin
done

####################################################
## zsh settings
####################################################

# general settings
setopt auto_cd                              # change to directory without cd
setopt interactive_comments                 # allow comments in interactive shell
setopt auto_menu                            # show completion menu on a successive tab press
setopt no_beep                              # disable beeping on tab completion
setopt complete_in_word                     # allow completion from both ends
setopt always_to_end                        # move cursor to end of completion

# history settings
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/zsh_history"
[[ ! -d ${HISTFILE:h} ]] && mkdir -p "${HISTFILE:h}"
HISTSIZE=50000
SAVEHIST=10000

setopt extended_history                     # save timestamp and duration of command
setopt hist_ignore_dups                     # ignore duplicate commands
setopt hist_ignore_space                    # ignore commands starting with space
setopt hist_reduce_blanks                   # remove leading and trailing blanks
setopt hist_expire_dups_first               # remove duplicates first when history is full
setopt hist_verify                          # verify history expansion
setopt share_history                        # share history between sessions
setopt inc_append_history                   # append new history to history file

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

# a list of non-alphanum chars considered part of a word by the line editor.
# zsh's default is "*?_-.[]~=/&;!#$%^(){}<>"
WORDCHAR='@_'

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
if type abbr &>/dev/null; then
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

typeset -gA key
key[Home]='^[[H'
key[End]='^[[F'
key[Insert]='^[[2~'
key[Backspace]='^?'
key[Ctrl-Backspace]='^H'
key[Delete]='^[[3~'
key[Ctrl-Delete]='^[[3;5~'
key[Up]='^[[A'
key[Down]='^[[B'
key[Left]='^[[D'
key[Right]='^[[C'
key[Ctrl-Left]='^[[1;5D'
key[Ctrl-Right]='^[[1;5C'
key[Alt-Left]='^[[1;3D'
key[Alt-Right]='^[[1;3C'
key[PageUp]='^[[5~'
key[PageDown]='^[[6~'
key[Shift-Tab]='^[[Z'
key[Ctrl-Z]='^Z'
key[Ctrl-/]='^_'
#key[Ctrl-R]='^R'
#key[Ctrl-K]='^K'

bindkey -- "${key[Home]}"           beginning-of-line
bindkey -- "${key[End]}"            end-of-line
bindkey -- "${key[Insert]}"         overwrite-mode
bindkey -- "${key[Delete]}"         delete-char
bindkey -- "${key[Ctrl-Delete]}"    delete-word
bindkey -- "${key[Up]}"             history-substring-search-up
bindkey -- "${key[Down]}"           history-substring-search-down
bindkey -- "${key[Left]}"           backward-char
bindkey -- "${key[Right]}"          forward-char
bindkey -- "${key[Ctrl-Left]}"      backward-word
bindkey -- "${key[Ctrl-Right]}"     forward-word
bindkey -- "${key[Alt-Left]}"       backward-word
bindkey -- "${key[Alt-Right]}"      forward-word
bindkey -- "${key[PageUp]}"         beginning-of-buffer-or-history
bindkey -- "${key[PageDown]}"       end-of-buffer-or-history
bindkey -- "${key[Shift-Tab]}"      reverse-menu-complete
bindkey -- "${key[Ctrl-Z]}"         undo
bindkey -- "${key[Ctrl-/]}"         redo
#bindkey -- "${key[Ctrl-R]}"         history-incremental-search-backward
#bindkey -- "${key[Ctrl-K]}"         kill-line

# NOTE these keybindings conflict with zsh-autopair
if ! type autopair-init &>/dev/null; then
  bindkey -- "${key[Backspace]}"      backward-delete-char
  bindkey -- "${key[Ctrl-Backspace]}" backward-kill-word
fi

# make switching between insert and normal mode faster
KEYTIMEOUT=10

####################################################
## end of keybinding
####################################################

####################################################
## misc
####################################################

# load zoxide autojump
source <(zoxide init zsh)

# To customize prompt, run `p10k configure` or edit $ZDOTDIR/.p10k.zsh.
[[ -f ${ZDOTDIR}/p10k.zsh ]] && source "$ZDOTDIR/p10k.zsh"
