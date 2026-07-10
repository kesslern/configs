# kesslern dotfiles

## Setup

1. Run a script in `install/` to install dependencies (`arch.sh` or `fedora.sh`).
2. From the `packages/` directory, run `stow <package>` to symlink a package's files into `$HOME`. To install everything: `stow */`

## Packages

- **emacs** — Emacs 30 config using built-in `use-package`, Eglot for LSP, Vertico/Corfu/Orderless for completion, Magit, tree-sitter, and diff-hl
- **terminal** — zsh (oh-my-zsh, candy theme), tmux, kitty, dircolors
- **ssh** — SSH client config with host aliases
- **sqlite** — column-mode output by default
- **utils** — small scripts in `~/.bin`: `urlencode`, `urldecode`, `hex2dec`, `dec2hex`, `hex2binary`, `chrome-remote-debug`, `24-bit-color-test.sh`

## Shell Features

+ Fuzzy shell history search with `fzf`
+ Directory jumping with `zoxide` (`z`)
+ `bd` — jump to any named parent directory
+ Append `JSON` to format command output as JSON
+ Append `XML` to format command output as XML
+ Append `COPY` to pipe output to the clipboard; `paste` prints clipboard contents
+ `swap_files <a> <b>` — atomically swap two files

## License

[MIT](./license.md)
