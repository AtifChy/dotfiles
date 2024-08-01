# fish git prompt config
set -g __fish_git_prompt_show_informative_status true
set -g __fish_git_prompt_char_cleanstate
set -g __fish_git_prompt_showcolorhints true

set -g __fish_git_prompt_color black --bold
set -g __fish_git_prompt_color_branch magenta --bold

set -g __fish_git_prompt_char_stagedstate '+'
set -g __fish_git_prompt_color_stagedstate green --bold

set -g __fish_git_prompt_showdirtystate true
set -g __fish_git_prompt_char_dirtystate '~'
set -g __fish_git_prompt_color_dirtystate yellow --bold 

set -g __fish_git_prompt_showuntrackedfiles true
set -g __fish_git_prompt_char_untrackedfiles '?'
set -g __fish_git_prompt_color_untrackedfiles red --bold

set -g __fish_git_prompt_char_invalidstate 'x'
set -g __fish_git_prompt_color_invalidstate red --bold

set -g __fish_git_prompt_showstashstate true
set -g __fish_git_prompt_char_stashstate '$'

set -g __fish_git_prompt_char_upstream_prefix "|$(set_color --bold red)"
set -g __fish_git_prompt_color_bare yellow --bold
set -g __fish_git_prompt_color_merging yellow --bold
