ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} * %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" "

_background="%K{19}"

setopt promptsubst

_first_line="${_background}%{$fg[green]%}%~ %{$reset_color%}${_background}$(git_prompt_info)${_background}"
_second_line="%(?:%{$fg[green]%}❯ :%{$fg_bold[red]%}❯ )%{$reset_color%}"

_invisible='%([BSUbfksu]|([FBK]|){*})'
_first_line_content=${(S)_first_line//$~_invisible}
_padding=${(l,COLUMNS-${#${(%)_first_line_content}},)}

PROMPT='$_first_line$_padding%{$reset_color%}'$'\n''${_second_line}'
