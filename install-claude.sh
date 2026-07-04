#!/bin/bash
# Install Claude Code and link its settings.json.
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SRC=$SCRIPT_DIR/claude/settings.json
DEST=$HOME/.claude/settings.json

create_symlink_backup() {
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

    ln -s "$1" "$2"
    echo "linked $2 -> $1"
}

# ---- install Claude Code ---------------------------------------------------
if command -v claude &> /dev/null; then
    echo "Claude Code already installed: $(command -v claude)"
else
    echo "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
fi

# ---- link settings ---------------------------------------------------------
if [[ ! -f $SRC ]]; then
    echo "error: settings not found at $SRC" >&2
    exit 1
fi

mkdir -p "$HOME/.claude"
create_symlink_backup "$SRC" "$DEST"

echo "Done. Run 'claude' to get started."
