ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} * %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" "

function _first_line() {
  echo "%{$fg[green]%}%~ %{$reset_color%}$(git_prompt_info)"
}
function _second_line() {
  echo "%(?:%{$fg[green]%}> :%{$fg_bold[red]%}> )%{$reset_color%}"
}

function _result_code() {
  RESULT="[$?]"
  echo "%(?:%{$fg[green]%}$RESULT:%{$fg_bold[red]%}$RESULT)%{$reset_color%}"
}

PROMPT='$(_first_line)'$'\n''$(_second_line)'
RPROMPT='$(_result_code)'
