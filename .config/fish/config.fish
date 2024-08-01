# source /etc/profile
if status is-login; and type -q fenv 
  fenv source /etc/profile
end

# exit if not running interactively
not status is-interactive; and return

if not type -q fisher
  curl -sL https://git.io/fisher | source
  and fisher install jorgebucaran/fisher
  and fisher update
end

# disable greeting on startup
set -g fish_greeting

# add to path if needed
fish_add_path -g "$HOME/.local/bin"
fish_add_path -g "$XDG_DATA_HOME/npm/bin"

# aliases
set -l LS 'ls'
command -q eza; and set LS eza

set -x LS_COLORS (dircolors -c | string split ' ')[3]

alias ls "$LS --color=auto --group-directories-first"
alias la 'ls -A'
alias ll 'ls -Alh'

alias cp 'cp -v'
alias mv 'mv -v'
alias rm 'rm -Iv'
alias ln 'ln -iv'
alias mkdir 'mkdir -pv'

alias grep 'grep --color=auto'
alias egrep 'egrep --color=auto'
alias fgrep 'fgrep --color=auto'

alias diff 'diff --color=auto'
alias ip 'ip --color=auto' 
alias ping 'ping -c 5 -W 30'
alias df 'df -h'
alias du 'du -ch'
alias dmesg 'dmesg -H'
alias free 'free -h'
alias visudo "EDITOR=$EDITOR command visudo"

alias :q exit
alias :x exit

# abbreviations
set -x ABBR_TIPS_PROMPT '\e[1;34mtip:\e[0m \e[1m{{ .abbr }}\e[0m => {{ .cmd }}'
set -x ABBR_TIPS_ALIAS_WHITELIST cd

function multicd
  echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd

abbr --add v nvim
abbr --add ff fastfetch
abbr --add sv sudoedit

if set -q WSLENV
  alias wsl wsl.exe
  alias winget winget.exe
  alias wezterm wezterm.exe
  alias wezterm-gui wezterm-gui.exe
  alias wezterm-mux-server wezterm-mux-server.exe

  function explorer
    command explorer.exe (wslpath -w -- $argv)
  end
end

# zoxide setup
zoxide init fish | source
