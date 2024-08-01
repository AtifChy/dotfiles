####################################################
## terminal title
####################################################

TERM_TITLE="%n@%m:%30<…<%~%<<"

setopt extended_glob

function title {
  # Don't set the title if inside emacs, unless using vterm
  [[ -n "${INSIDE_EMACS:-}" && "$INSIDE_EMACS" != vterm ]] && return
  
  # if $2 is unset use $1 as default
  # if it is set and empty, leave it as is
  : ${2=$1}

  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|konsole*|ansi|mlterm*|alacritty|st*|wezterm*)
      print -Pn "\e]2;${2:q}\a"
      print -Pn "\e]1;${1:q}\a"
      ;;
    screen*|tmux*)
      print -Pn "\ek${1:q}\e\\"
      ;;
  esac
}

function title_precmd {
  title "$TERM_TITLE"
}

function title_preexec {
  local CMD="${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}"
  local LINE="${2:gs/%/%%}"

  title "$CMD" "%50>...>${LINE}%<<"
}

add-zsh-hook -Uz precmd title_precmd
add-zsh-hook -Uz preexec title_preexec

unsetopt extended_glob
