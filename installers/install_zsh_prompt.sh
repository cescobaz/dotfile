#!/bin/bash

echo """
# prompt style
# http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
PROMPT='%F{yellow}%~ %(1j.%j.)
%F{yellow}> %b%f'
RPROMPT="%\(?.%F{yellow}[%?]%f.%B%F{red}[%?]%f%b"
""" >> ~/.zshrc
