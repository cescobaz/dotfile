ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} * %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" "

setopt promptsubst

function _background() {
  echo "%K{19}"
}

function _first_line() {
  echo "$(_background)%{$fg[green]%}%~ %{$reset_color%}$(_background)$(git_prompt_info)$(_background)"
}
function _second_line() {
  echo "%(?:%{$fg[green]%}❯ :%{$fg_bold[red]%}❯ )%{$reset_color%}"
}

function _padding() {
  _invisible='%([BSUbfksu]|([FBK]|){*})'
  _first_line_content=${(S)$(_first_line)//$~_invisible}
  echo "${(l,COLUMNS-${#${(%)_first_line_content}},)}"
}

PROMPT='$(_first_line)$(_padding)%{$reset_color%}'$'\n''$(_second_line)'
