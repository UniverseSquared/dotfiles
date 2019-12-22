# If antigen is missing, download it
ANTIGEN_PATH=$HOME/.zsh/antigen.zsh

[ ! -f $ANTIGEN_PATH ] && curl -L git.io/antigen > $ANTIGEN_PATH

# Antigen - load zsh-syntax-highlighting and theme
source $ANTIGEN_PATH

antigen use oh-my-zsh

antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme fishy

antigen apply

# Aliases
alias ls=exa
alias dotfiles-git="git --git-dir=$HOME/dotfiles --work-tree=$HOME"

export PATH="$PATH:$HOME/.cargo/bin"
