typeset -g TERM_TITLE="%n@%m:%30<…<%~%<<"

emulate -L zsh -o extended_glob

function __title {
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

function __title_precmd {
  __title "$TERM_TITLE"
}

function __title_preexec {
  local CMD="${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}"
  local LINE="${2:gs/%/%%}"

  __title "$CMD" "%50>...>${LINE}%<<"
}

add-zsh-hook -Uz precmd __title_precmd
add-zsh-hook -Uz preexec __title_preexec
