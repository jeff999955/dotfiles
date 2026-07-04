# dotfiles

My macOS environment configuration.

## Programs

Terminal related:

* zsh
  * oh-my-zsh (`robbyrussell` theme; `git`, `zsh-autosuggestions`,
    `zsh-syntax-highlighting`, `z` plugins)
* tmux
* ssh (host config only — no keys)
* ghostty
* git

Apps:

* linearmouse
* uv
* Claude Code (`claude/settings.json`)
* Visual Studio Code (`vscode/settings.json`)

## Install

```sh
./install.sh          # shell / terminal dotfiles
./install-claude.sh   # Claude Code + settings
./install-vscode.sh   # VS Code + settings
```

`install.sh` symlinks the top-level rc files into `$HOME`, links `.ssh/config`
into `~/.ssh/config` (never keys), and clones the external oh-my-zsh plugins.

`install-claude.sh` installs Claude Code (via the official installer) and links
`claude/settings.json` into `~/.claude/settings.json`.

`install-vscode.sh` installs VS Code (downloaded straight from Microsoft, no
Homebrew) and links `vscode/settings.json` into VS Code's user-settings path.
The VS Code config references `${env:OVERLEAF_GIT_TOKEN}` instead of a hard-coded
token — export it in your shell rc so VS Code can resolve it.

Each installer backs up any existing config before linking, and is a no-op if
the target is already the right symlink.

## License

Licensed under [MIT](LICENSE).
