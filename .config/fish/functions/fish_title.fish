function fish_title
  # emacs' "term" is basically the only term that can't handle it.
  if not set -q INSIDE_EMACS; or string match -vq '*,term:*' -- $INSIDE_EMACS
    # If we're connected via ssh, we print the hostname.
    set -l ssh
    set -q SSH_TTY
    and set ssh "["(prompt_hostname | string sub -l 10 | string collect)"]"
    # An override for the current command is passed as the first parameter.
    # This is used by `fg` to show the true process name, among others.
    if set -q argv[1]
      set argv (string split ' ' $argv[1])
      set -l out
      set -l cmd $argv[1]
      
      if command -q $cmd; or functions -q $cmd
        set out $cmd
        for i in (seq 2 (count $argv))
          if string match -qr '[.~\w]+/[^\s]*' -- $argv[$i]
            set -a out (basename $argv[$i])
          else
            set -a out $argv[$i]
          end
        end
      else
        set out (string replace -ar '\n' '; ' -- $argv)
      end
      
      set out (string join ' ' -- $out | string shorten -m 30)

      echo -- $ssh $out
    else
      set -l login "$USER"@(prompt_hostname):
      echo -- $ssh $login (prompt_pwd)
    end
  end
end
