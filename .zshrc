export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME='robbyrussell'

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY='true'

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# NVM_LAZY_LOAD='true'
plugins=(
    zsh-nvm
)

source $ZSH/oh-my-zsh.sh

alias vim=/usr/local/bin/vim
alias emacs=/usr/local/bin/emacs
source ~/.p/aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
