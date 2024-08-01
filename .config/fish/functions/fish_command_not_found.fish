function fish_command_not_found
  set -l cmd $argv[1]

  if not command -q pkgfile
    __fish_default_command_not_found_handler $cmd
    return
  end

  set -l red (set_color -o red)
  set -l green (set_color -o green)
  set -l magenta (set_color -o magenta)
  set -l white (set_color -o white)
  set -l normal (set_color normal)

  set -l pkgs (
     pkgfile -bvw -- $cmd 2>/dev/null | string replace -r '\t' ' ' | string replace '/' ' '
  )

  if test $status -eq 0
    printf "$red%s$normal may be found in the following packages:\n" $cmd
    for pkg in $pkgs
      set -l fields (string split ' ' $pkg)
      printf "$magenta%s/$white%s $green%s$normal\t%s\n" $fields[1] $fields[2] $fields[3] $fields[4]
    end
  else
    __fish_default_command_not_found_handler $cmd
  end
end
