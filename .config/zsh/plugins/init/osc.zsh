# adds OSC 7 support 
# reqired by some terminals to get the current working directory

function _osc_precmd() {
  print -Pn "\e]7;file://%m%d\e\\"
}
add-zsh-hook -Uz precmd _osc_precmd
