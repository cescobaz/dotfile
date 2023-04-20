#!/bin/bash

# /usr/local/opt/fzf/install

echo """# fzf
export FZF_DEFAULT_COMMAND=\"fd --type f\"
export FZF_DEFAULT_OPTS="--layout=reverse --history=/Users/buro/.fzf_history --color='fg:07,bg:0,preview-fg:07,preview-bg:0,hl:03,fg+:15,bg+:18,gutter:00,hl+:03,info:18,border:00,prompt:07,pointer:03,marker:03,spinner:07,header:03' --no-bold"
""" >> ~/.zshrc
