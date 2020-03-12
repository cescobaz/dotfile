ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} * %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" "

PROMPT='%{$fg[green]%}%c %{$reset_color%}$(git_prompt_info)%(?:%{$fg[green]%}❯ :%{$fg_bold[red]%}❯ )%{$reset_color%}'
