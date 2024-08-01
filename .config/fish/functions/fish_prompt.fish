set normal (set_color normal)

function __prompt_pwd
  set -q color_pwd; or set -l color_pwd cyan --bold
  set -l color_icon $color_pwd
  not test -w $PWD; and set color_icon red --bold

  echo -n -s (set_color $color_icon)' ' (set_color $color_pwd)(prompt_pwd)$normal
end

function __fish_git_prompt
  set -q __fish_git_prompt_color; or set -g __fish_git_prompt_color white --bold
  set -q __fish_git_prompt_color_merging; or set -g __fish_git_prompt_color_merging yellow --bold

  set -l vcs (fish_git_prompt %s | string split '|')
  set -l separator "$(set_color $__fish_git_prompt_color)|$(set_color $__fish_git_prompt_color_merging)"
  set -l vcs_prompt (string join $separator $vcs)

  echo -n -s " "(set_color $__fish_git_prompt_color)"["$vcs_prompt(set_color $__fish_git_prompt_color)"]"$normal
end

function __cmd_duration
  test -z $CMD_DURATION; and return

  set -l seconds (math "$CMD_DURATION / 1000")

  set -l days (math --scale 0 "$seconds / 86400")
  set -l remainder (math "$seconds % 86400")

  set -l hours (math --scale 0 "$remainder / 3600")
  set -l remainder (math "$remainder % 3600")

  set -l minutes (math --scale 0 "$remainder / 60")
  set -l seconds (math --scale 0 "$remainder % 60")

  set -l output

  test $days -gt 0; and set -a output "$days"d
  test $hours -gt 0; and set -a output "$hours"h
  test $minutes -gt 0; and set -a output "$minutes"m
  test $seconds -gt 0; and set -a output "$seconds"s
  
  test $output[1] = "$seconds"s 2>/dev/null
  and test $seconds -le 5; and return
  
  echo -n -s " "(set_color --bold yellow)(string join '' -- $output)$normal
end

function fish_prompt
  set -l last_pipestatus $pipestatus
  set -lx __fish_last_status $status
  set -q fish_color_status; or set fish_color_status red

  set -l suffix_color green
  test $__fish_last_status -ne 0; and set suffix_color $fish_color_status
  set -l suffix '➜'

  # Write pipestatus [ Note: taken from default `fish_prompt` function ]
  # If the status was carried over (if no command is issued or if `set` leaves the status untouched), don't bold it.
  set -l bold_flag --bold
  set -q __fish_prompt_status_generation
  or set -g __fish_prompt_status_generation $status_generation

  test $__fish_prompt_status_generation = $status_generation; and set bold_flag
  set __fish_prompt_status_generation $status_generation
  set -l status_color (set_color $fish_color_status)
  set -l statusb_color (set_color $bold_flag $fish_color_status)
  set -l prompt_status " "(__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
  
  echo -s (__prompt_pwd) (__fish_git_prompt) (__cmd_duration) $prompt_status
  echo -n -s (set_color $suffix_color)$suffix$normal " "
end

set async_prompt_functions __prompt_pwd __fish_git_prompt __cmd_duration

function __prompt_pwd_loading_indicator
  echo -n (set_color brblack)…$normal
end

function __fish_git_prompt_loading_indicator
  echo -n (set_color brblack)…$normal
end

function __cmd_duration_loading_indicator
  echo -n (set_color brblack)…$normal
end
