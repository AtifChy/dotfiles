# xdg environment variables
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_STATE_HOME "$HOME/.local/state"

# default editor
set -x EDITOR (
  for editor in nvim vim nano vi
    if command -q $editor
      echo -n $editor
      break
    end
  end
)

# sudo prompt
set -x SUDO_PROMPT (
  set -l sudo_color (set_color red --bold --reverse) 
  set -l user_color (set_color magenta)
  set -l normal (set_color normal)
  echo -n -s $sudo_color'[sudo]'$normal' password for '$user_color'%p'$normal': '
)

# ssh config 
set -x SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

# gpg config
set -x GPG_TTY (tty)

# color manpages
set -x LESS '-F -R --use-color -Dd+r$Du+b$DS+ky$DP+kg$DE+kR$'
set -x MANROFFOPT '-P -c'

# git config
set -l git_config_dir "$XDG_CONFIG_HOME/git"
not test -d "$git_config_dir"; and mkdir -p "$git_config_dir"

for file in $HOME/.{gitconfig,gitignore,gitattributes,git-credentials,gitk}
  if test -f $file
    set -l base_name (string match -r '[^/]*$' -- $file)
    switch $base_name
      case '.gitk'
        mv $file "$git_config_dir/gitk"
      case '*'
        mv $file "$git_config_dir"/(string replace -r '\.git-?' '' -- $base_name)
    end
  end
end

# wget
set -x WGETRC "$XDG_CONFIG_HOME/wget/wgetrc"
if not test -f "$WGETRC"
  echo "hsts-file = $XDG_CACHE_HOME/wget-hsts" >> "$WGETRC"
end

# node
set -x NODE_REPL_HISTORY "$XDG_DATA_HOME/node_repl_history"
set -x NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
if not test -f "$NPM_CONFIG_USERCONFIG"
  mkdir -p (dirname "$NPM_CONFIG_USERCONFIG")
  echo "\
prefix=$XDG_DATA_HOME/npm
cache=$XDG_CACHE_HOME/npm
init-module=$XDG_CONFIG_HOME/npm/config/npm-init.js
logs-dir=$XDG_STATE_HOME/npm/logs\
" >> "$NPM_CONFIG_USERCONFIG"
end

# go
set -x GOPATH "$XDG_DATA_HOME/go"

# rust
set -x CARGO_HOME "$XDG_DATA_HOME/cargo"
set -x RUSTUP_HOME "$XDG_DATA_HOME/rustup"

# sqlite 
set -x SQLITE_HISTORY "$XDG_DATA_HOME/sqlite/history"

# ranger
set -x RANGER_LOAD_DEFAULT_RC false
