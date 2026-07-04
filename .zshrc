# ~/.zshrc — oh-my-zsh setup

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export TERM="xterm-256color"

# Theme. See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Plugins. zsh-autosuggestions and zsh-syntax-highlighting are external and
# must be cloned into $ZSH/custom/plugins (see README / install.sh).
plugins=(git zsh-autosuggestions zsh-syntax-highlighting z)

source "$ZSH/oh-my-zsh.sh"

# ---- User configuration ----------------------------------------------------

# Personal scripts / user-installed binaries
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

