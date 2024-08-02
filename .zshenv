export ZDOTDIR="$HOME/.config/zsh"
[[ -d $ZDOTDIR ]] || mkdir -p "$ZDOTDIR"
[[ -f $ZDOTDIR/.zshenv ]] && source "$ZDOTDIR/.zshenv"
