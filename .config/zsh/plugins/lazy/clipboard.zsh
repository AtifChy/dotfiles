# based on ohmyzsh lib/clipboard.zsh

function detect-clipboard() {
  emulate -L zsh

  if [[ -n "${WAYLAND_DISPLAY:-}" && ${commands[wl-copy]} && ${commands[wl-paste]} ]]; then
    function clipcopy() { wl-copy < "${1:-/dev/stdin}" &>/dev/null }
    function clippaste() { wl-paste --no-newline }
  elif [[ -n "${DISPLAY:-}" && ${commands[xsel]} ]]; then
    function clipcopy() { xsel --clipboard --input < "${1:-/dev/stdin}" }
    function clippaste() { xsel --clipboard --output }
  elif [[ -n "${DISPLAY:-}" && ${commands[xclip]} ]]; then
    function clipcopy() { xclip -selection clipboard -in < "${1:-/dev/stdin}" }
    function clippaste() { xclip -selection clipboard -out }
  elif (( ${+commands[win32yank.exe]} )); then
    function clipcopy() { win32yank.exe -i < "${1:-/dev/stdin}" }
    function clippaste() { win32yank.exe -o }
  else
    print -P "%B%F{red}error:%f%b no supported clipboard utility found" >&2
    return 1
  fi
}

function clipcopy clippaste {
  unfunction clipcopy clippaste
  detect-clipboard || return
  "$0" "$@"
}
