# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/Users/cescobaz/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
PROMPT='%B%F{green}%~ %(1j.%j.)
%F{green}> %b%f'
RPROMPT="%(?.%F{green}[%?]%f.%B%F{red}[%?]%f%b"

setopt share_history
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

test -e ~/.shell_env && source ~/.shell_env || true
test -e ~/.custom_env && source ~/.custom_env || true
test -e ~/.aliases && source ~/.aliases || true
test -e ~/.custom_aliases && source ~/.custom_aliases || true
