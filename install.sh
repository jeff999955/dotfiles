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

create_symlink_backup() {
    if [[ $# -ne 2 ]]; then
        echo $FUNCNAME: expect 2 arguments, got $#
        echo usage: $FUNCNAME src dest
        return 1
    fi

    # Already the symlink we want; nothing to do.
    if [[ -L $2 && $(readlink "$2") == "$1" ]]; then
        echo "$2 already linked -> $1"
        return 0
    fi

    # Back up any existing file/symlink before linking.
    if [[ -e $2 || -L $2 ]]; then
        backup=$2.backup.$(date +%Y%m%d%H%M%S)
        mv "$2" "$backup"
        echo "backed up $2 -> $backup"
    fi

    ln -s $1 $2
    echo "linked $2 -> $1"
}

# ---- top-level rc files ----------------------------------------------------
# Everything at the repo root except metadata and the .ssh dir (handled below).
# .zshrc is handled in the oh-my-zsh section since it depends on omz.
for file in $(find $SCRIPT_DIR -maxdepth 1 -type f \( \
                -not -name 'README.md'                \
                -and -not -name 'LICENSE'             \
                -and -not -name '.gitignore'          \
                -and -not -name '.zshrc'              \
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

# ---- oh-my-zsh + zsh config ------------------------------------------------
# .zshrc and the external plugins assume oh-my-zsh is present, so gate them on it.
if [[ ! -d $HOME/.oh-my-zsh ]]; then
    read -r -p "oh-my-zsh not found. Install it now? [Y/n] " reply
    if [[ ! $reply =~ ^[Nn]$ ]]; then
        # Link our .zshrc first so the installer preserves it (--keep-zshrc).
        create_symlink_backup $SCRIPT_DIR/.zshrc $HOME/.zshrc
        RUNZSH=no CHSH=no sh -c \
            "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
            "" --unattended --keep-zshrc
    fi
fi

if [[ -d $HOME/.oh-my-zsh ]]; then
    create_symlink_backup $SCRIPT_DIR/.zshrc $HOME/.zshrc

    ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
    [[ -d $ZSH_CUSTOM/plugins/zsh-autosuggestions ]] || \
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    [[ -d $ZSH_CUSTOM/plugins/zsh-syntax-highlighting ]] || \
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "Skipping .zshrc and zsh plugins (oh-my-zsh not installed)."
fi
