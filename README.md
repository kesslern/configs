# kesslern dotfiles

## Setup
Use the script in `install/arch.sh` to set up dependencies.

## Features
+ Fuzzy shell history search with `fzf`
+ emacs wrapper script aliased to `ew` and `nano`
+ tmux plugin manager setup
+ [autojump](https://github.com/wting/autojump) aliased to `j`
+ Append `JSON` to the end of a shell command to format the output as JSON
+ Append `XML` to the end of a shell command to format the output as XML
+ Command auto-fixin with [thefuck](https://github.com/nvbn/thefuck)
+ Pipe to `copy` to copy text or `paste` to use the clipboard
+ [exa](https://github.com/ogham/exa) aliased to `e`

## Setup

Run `install/arch.sh` for Arch Linux.

### Generating the dotfiles
Dotfiles are generated using [dot-templater](https://github.com/kesslern/dot-templater).

Clone the repository and use dot-templater to template the files. Although dot-templater could place the dotfiles directly into your home directory, it is recommended to place them into a hidden subdirectory and use GNU Stow to link the dotfiles into the home directory.

```bash
./apply.sh [TEMPLATE]
```

## License

[MIT](./license.md)
