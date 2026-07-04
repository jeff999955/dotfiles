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

## Install

```sh
./install.sh
```

`install.sh` symlinks the top-level rc files into `$HOME`, links `.ssh/config`
into `~/.ssh/config` (never keys), and clones the external oh-my-zsh plugins.

## License

Licensed under [MIT](LICENSE).
