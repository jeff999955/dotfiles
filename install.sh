#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

create_symlink() {
    if [[ $# -ne 2 ]]; then
        echo $FUNCNAME: expect 2 arguments, got $#
        echo usage: $FUNCNAME src dest
        return 1
    fi

    if [[ ! -e $2 ]]; then
        ln -s $1 $2
        echo "linked $2 -> $1"
    else
        echo "$2 exists, skipping"
    fi
}

# ---- top-level rc files ----------------------------------------------------
# Everything at the repo root except metadata and the .ssh dir (handled below).
for file in $(find $SCRIPT_DIR -maxdepth 1 -type f \( \
                -not -name 'README.md'                \
                -and -not -name 'LICENSE'             \
                -and -not -name '.gitignore'          \
                -and -not -name $(basename "$0")      \
    \)); do

    create_symlink $file $HOME/${file##*/}
done

# ---- ssh config ------------------------------------------------------------
# Link only the config file, never keys. Keep ~/.ssh private.
mkdir -p $HOME/.ssh
chmod 700 $HOME/.ssh
create_symlink $SCRIPT_DIR/.ssh/config $HOME/.ssh/config

# ---- .config folders -------------------------------------------------------
if [[ -d $SCRIPT_DIR/.config ]]; then
    mkdir -p $HOME/.config
    for dir in $(find $SCRIPT_DIR/.config/ -mindepth 1 -maxdepth 1 -type d); do
        create_symlink $dir $HOME/.config/${dir##*/}
    done
fi

# ---- oh-my-zsh + external plugins ------------------------------------------
if [[ ! -d $HOME/.oh-my-zsh ]]; then
    echo "oh-my-zsh not found. Install it with:"
    echo '  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [[ -d $HOME/.oh-my-zsh ]]; then
    [[ -d $ZSH_CUSTOM/plugins/zsh-autosuggestions ]] || \
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    [[ -d $ZSH_CUSTOM/plugins/zsh-syntax-highlighting ]] || \
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi
