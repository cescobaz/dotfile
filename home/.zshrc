# oh my zsh configuration
export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM=$HOME/.zsh_custom
DISABLE_UNTRACKED_FILES_DIRTY='true'

ZSH_THEME='buro'

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
# start user configuration

setopt share_history

test -e ~/.shell_env && source ~/.shell_env || true
test -e ~/.custom_env && source ~/.custom_env || true
test -e ~/.aliases && source ~/.aliases || true
test -e ~/.custom_aliases && source ~/.custom_aliases || true
