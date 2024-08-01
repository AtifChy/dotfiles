function command_not_found_handler() {
  local pkgs cmd="$1"
  
  pkgs=(${(f)"$(pkgfile -bvw -- "$cmd" 2>/dev/null)"})
  
  if [[ -n "$pkgs" ]]; then
    printf '\e[31;1m%s\e[0m may be found in the following packages:\n' "$cmd"
    for pkg in $pkgs[@]; do
      pkg=(${=pkg})
      repo=${pkg[1]%%/*}
      name=${pkg[1]##*/}
      version=$pkg[2]
      bin=$pkg[3]
      printf '  \e[35;1m%s/\e[37;1m%s \e[32;1m%s\e[0m \t%s\n' \
        "$repo" "$name" "$version" "$bin"
    done
  else
    printf 'zsh: command not found: %s\n' "$cmd"
  fi 1>&2

  return 127
}
