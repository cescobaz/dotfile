# The following lines were added by compinstall

zstyle ':completion:*' completer _extensions _complete _ignored
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
# show a description of the completion grouped
zstyle ':completion:*:*:*:*:descriptions' format '%F{yellow}-- %d --%f'
# show all info about files
zstyle ':completion:*' file-list all
# sort files by change on FS
zstyle ':completion:*' file-sort change
# show the menu with selection when there is at least 1 match
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
zstyle :compinstall filename '/Users/cescobaz/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
PROMPT='%F{green}%~ %(1j.%j.)
%F{green}> %b%f'
RPROMPT="%(?.%F{green}[%?]%f.%B%F{red}[%?]%f%b"

setopt share_history
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

alias ls='exa --color=always'
alias ll='exa -l --color=always'
alias lla='exa -la --color=always'
if [ "$TERM" = "xterm-kitty" ]; then
  alias ssh='kitty +kitten ssh'
fi

test -e ~/.shell_env && source ~/.shell_env || true
test -e ~/.custom_env && source ~/.custom_env || true
test -e ~/.aliases && source ~/.aliases || true
test -e ~/.custom_aliases && source ~/.custom_aliases || true
