####################################################
## keybinding
####################################################

# enable emacs keybinding
bindkey -e

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
bindkey -M menuselect '?' history-incremental-search-forward
bindkey -M menuselect '/' history-incremental-search-backward
bindkey -M menuselect '^?' send-break               # ctrl-backspace
bindkey -M menuselect '^[' kill-buffer              # esc

# make switching between insert and normal mode faster
KEYTIMEOUT=10

####################################################
## end of keybinding
####################################################
