# ~/.zshrc — oh-my-zsh setup

# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme. See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Plugins. zsh-autosuggestions and zsh-syntax-highlighting are external and
# must be cloned into $ZSH/custom/plugins (see README / install.sh).
plugins=(git zsh-autosuggestions zsh-syntax-highlighting z)

source "$ZSH/oh-my-zsh.sh"

# ---- User configuration ----------------------------------------------------

# Personal scripts / user-installed binaries
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

# uv / rust shims (writes $HOME/.local/bin/env)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# LM Studio CLI (lms)
[ -d "$HOME/.lmstudio/bin" ] && export PATH="$PATH:$HOME/.lmstudio/bin"

# opencode
[ -d "$HOME/.opencode/bin" ] && export PATH="$HOME/.opencode/bin:$PATH"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                       # load nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"    # load nvm completion
