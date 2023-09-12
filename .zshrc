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
alias dfg="git --git-dir=$HOME/dotfiles --work-tree=$HOME"

ytmp3() {
    youtube_url=$1
    output_filename="${@:2}"

    youtube-dl "$youtube_url" \
               --extract-audio --audio-format=mp3 \
               -o "$output_filename.%(ext)s"
}

export PATH="$PATH:$HOME/.cargo/bin"

OPAM_INIT=$HOME/.opam/opam-init/init.zsh

[[ -f $OPAM_INIT ]] && source $OPAM_INIT
