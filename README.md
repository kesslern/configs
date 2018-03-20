# kesslern dotfiles

## Dependencies
+ git
+ zsh
+ emacs 24+
+ tmux
+ if using i3:
  + i3
  + polybar
  + feh
  + compton
+ if using `kb-light.py` to change keyboard backlight:
  + python3
  + upower

## Setup

### oh-my-zsh
[Full documentation here.](https://github.com/robbyrussell/oh-my-zsh)
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

### Spacemacs
[Full documentation here.](https://github.com/syl20bnr/spacemacs)
```bash
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
```

### Generate the dotfiles
Dotfiles are generated using [dot-templater](https://github.com/kesslern/dot-templater).

Clone the repository and use dot-templater to template the files. Although dot-templater could place the dotfiles directly into your home directory, it is recommended to place them into a hidden subdirectory and use GNU Stow to link the dotfiles into the home directory.
```bash
git clone https://github.com/kesslern/configs.git
cd configs/
mkdir ~/.dotfiles
dot-templater [TEMPLATE] dotfiles ~/.dotfiles
stow -t ~ -d ~/.dotfiles .
```

## License

MIT

Copyright (c) 2017 Nathan Kessler

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.