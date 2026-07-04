#!/bin/bash
# Install Visual Studio Code and link its settings.json.
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

SRC=$SCRIPT_DIR/vscode/settings.json
# macOS user-settings location.
DEST="$HOME/Library/Application Support/Code/User/settings.json"

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

# ---- install VS Code -------------------------------------------------------
# Download the official universal build straight from Microsoft (no Homebrew).
APP="/Applications/Visual Studio Code.app"
if [[ -d "$APP" ]] || command -v code &> /dev/null; then
    echo "VS Code already installed."
else
    echo "Downloading VS Code from Microsoft..."
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    curl -fSL "https://code.visualstudio.com/sha/download?build=stable&os=darwin-universal" \
        -o "$tmp/vscode.zip"
    echo "Unpacking to /Applications..."
    ditto -x -k "$tmp/vscode.zip" /Applications
fi

# Put the `code` CLI on PATH if the app bundle ships it.
if ! command -v code &> /dev/null && [[ -x "$APP/Contents/Resources/app/bin/code" ]]; then
    ln -sf "$APP/Contents/Resources/app/bin/code" /usr/local/bin/code 2>/dev/null \
        && echo "linked 'code' CLI -> /usr/local/bin/code" \
        || echo "note: could not link 'code' to /usr/local/bin (add it to PATH manually)"
fi

mkdir -p "$(dirname "$DEST")"
create_symlink_backup "$SRC" "$DEST"

# ---- reminder: secret env var ----------------------------------------------
# settings.json references ${env:OVERLEAF_GIT_TOKEN} instead of a hard-coded
# token. VS Code only resolves it if the var is set in the env it inherits.
if [[ -z "${OVERLEAF_GIT_TOKEN:-}" ]]; then
    echo
    echo "NOTE: OVERLEAF_GIT_TOKEN is not set. Add it to your shell rc, e.g.:"
    echo "  echo 'export OVERLEAF_GIT_TOKEN=your-token-here' >> ~/.zshrc"
    echo "Then restart VS Code (from that shell) so it inherits the variable."
fi

echo "Done. Launch VS Code to pick up the settings."
