# kesslern dotfiles

## Dependencies
+ git
+ dot-templator
+ Cascadia Code

## Supported Applications
+ zsh
  + oh-my-zsh
  + fzf history search
+ emacs
+ tmux
  + tmux plugin manager
+ autojump
+ i3
  + picom
  + feh
    + Wallpaper at `~/.wallpaper.jpg` is set
    + Wallpapers in `~/.wallpapers` are cycled every 20 minutes
+ python3 for formatting JSON
  + append `JSON` to the end of a shell command to format the output as JSON
+ xmllint for formattting XML
  + append `XML` to the end of a shell command to format the output as XML
+ lesspipe
+ thefuck
+ xclip (Linux) or pbcopy/pbpaste (MacOS)
  + aliases to `copy` and `paste`
+ exa
  + aliased to `e`

## Setup

Run `install/arch.sh` for Arch Linux.

### Manual Setup

Install dependencies then install `oh-my-zsh` and the Tmux Plugin Manager.

#### oh-my-zsh
[Full documentation here.](https://github.com/robbyrussell/oh-my-zsh)
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

#### Tmux Plugin Manager
[Full documentation here.](https://github.com/tmux-plugins/tpm)
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Generate the dotfiles
Dotfiles are generated using [dot-templater](https://github.com/kesslern/dot-templater).

Clone the repository and use dot-templater to template the files. Although dot-templater could place the dotfiles directly into your home directory, it is recommended to place them into a hidden subdirectory and use GNU Stow to link the dotfiles into the home directory.
```bash
git clone https://github.com/kesslern/configs.git
cd configs/
./apply.sh [TEMPLATE]
```

## License

[MIT](./license.md)
