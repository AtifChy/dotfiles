# xdg specification variables
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# set default editor
export EDITOR="${${commands[nvim]:-${commands[vim]:-nano}}:t}"

# sudo prompt
export SUDO_PROMPT=$'\e[1;7;31m[sudo]\e[0m password for \e[35m%p\e[0m: '

# ssh config
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# gpg config
export GPG_TTY="$(tty)"

# less config
export LESS='-F -R --use-color -Dd+r$Du+b$DS+ky$DP+kg$DE+kR$'

# manpages config
export MANROFFOPT='-P -c'

# git config
local GIT_CONFIG_DIR="$XDG_CONFIG_HOME/git"
[[ ! -d ${GIT_CONFIG_DIR} ]] && mkdir -p ${GIT_CONFIG_DIR}
for file in $HOME/.{gitconfig,gitignore,gitattributes,git-credentials,gitk}; do
  if [[ -f $file ]]; then
    _basename=${file:t}
    case $_basename in
      '.gitk')
        mv -b $file ${GIT_CONFIG_DIR}/gitk
        ;;
      '.git-credentials')
        mv -b $file ${GIT_CONFIG_DIR}/credentials
        ;;
      *)
        mv -b $file ${GIT_CONFIG_DIR}/${_basename//.git/}
        ;;
    esac
  fi
done

# wget
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
if [[ ! -f $WGETRC ]]; then
  mkdir -p ${WGETRC:h}
  echo "hsts-file=$XDG_CACHE_HOME/wget-hsts" >> "$WGETRC"
fi

# node
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node/repl_history"
[[ ! -f $NODE_REPL_HISTORY ]] && mkdir -p ${NODE_REPL_HISTORY:h}

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
if [[ ! -f $NPM_CONFIG_USERCONFIG ]]; then
  mkdir -p ${NPM_CONFIG_USERCONFIG:h}
  tee <<EOF >> "$NPM_CONFIG_USERCONFIG"
prefix=$XDG_DATA_HOME/npm
cache=$XDG_CACHE_HOME/npm
init-module=$XDG_CONFIG_HOME/npm/config/init.js
logs-dir=$XDG_STATE_HOME/npm/logs
EOF
fi

# go
export GOPATH="$XDG_DATA_HOME/go"

# rust
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# sqlite
export SQLITE_HISTORY="$XDG_DATA_HOME/sqlite/history"

# ranger
export RANGER_LOAD_DEFAULT_RC=false
