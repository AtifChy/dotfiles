typeset -gA abbrs=(_foo _bar)
typeset -gi ABBR_TIPS_STATUS=1

function abbr() {
  zparseopts -D -F -- {h,-help}=help L=list m=match e=erase || return

  if (( $#help )); then
    print -P "%B%F{green}Usage%f%b: $0 [options] abbr=cmd"
    print -P " -h, --help   show this help message."
    print -P " -L           print each abbr in the form of calls to abbr."
    print -P " -m <args..>  match abbreviation."
    print -P " -e <args..>  remove abbreviation."
    return 0
  fi

  if (( $#list )); then
    abbr-list --cmd
    return 0
  fi

  if (( $#match )); then
    alias -m $@
    return 0
  fi

  if (( $#erase )); then
    unabbr $@
    return 0
  fi

  if (( ! $# )); then
    abbr-list
    return 0
  fi

  local abbr=${1%%=*}
  local cmd=${1#*=}
  if [[ -n $abbr && -n $cmd ]]; then
    abbrs[$abbr]=$cmd
    alias $abbr=$cmd
  else
    print -P "%B%F{red}error%f%b: invalid abbreviation."
  fi
}

function unabbr() {
  if [[ $1 =~ "-h|--help" ]]; then
    print -P "%B%F{green}Usage%f%b: $0 [options] abbr"
    print -P " -h, --help   show this help message."
    return 0
  fi

  local abbr=$1
  if [[ $abbrs[$abbr] ]]; then
    unset "abbrs[$abbr]"
    unalias $abbr
    print -P "%B%F{green}success%f%b: abbreviation removed."
  else
    print -P "%B%F{red}error%f%b: invalid abbreviation."
  fi
}

function abbr-list() {
  if [[ $1 =~ '-h|--help' ]]; then
    print -P "%B%F{green}Usage%f%b: $0 [options]"
    print -P " -h, --help   show this help message."
    print -P " --cmd        print each abbr in the form of calls to abbr."
    return 0
  fi

  for abbr cmd in ${(kv)abbrs}; do
    if [[ $abbr != '_foo' ]]; then
      if [[ $1 == '--cmd' ]]; then
        printf 'abbr %s=%s\n' ${(qq)abbr} ${(qq)cmd}
      else
        printf '\e[34;1m%-10s\e[0m => %s\n' $abbr $cmd
      fi
    fi
  done | sort
}

function _abbr_match() {
  if [[ ${LBUFFER} =~ '(^|\s)('${(j:|:)${${(k)abbrs}//\./\\.}}')$' ]]; then
    zle _expand_alias
    ABBR_TIPS_STATUS=0
  fi
}

function abbr-expend() {
  _abbr_match
  zle .self-insert
}
zle -N abbr-expend

function abbr-expend-end-of-line() {
  _abbr_match
  zle .end-of-line
}
zle -N abbr-expend-end-of-line

bindkey ' ' abbr-expend
bindkey '^[[F' abbr-expend-end-of-line
bindkey '^ ' magic-space
#bindkey -M isearch ' ' self-insert

function abbr-expend-and-accept-line() {
  abbr-expend
  zle .backward-delete-char
  zle .accept-line
}
zle -N accept-line abbr-expend-and-accept-line