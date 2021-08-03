#!/bin/bash

echo "Installing dependencies..."
sudo pacman -S --noconfirm \
  compton \
  emacs \
  exa \
  feh \
  fzf \
  i3-wm \
  lesspipe \
  libxml2 \
  python \
  stow \
  thefuck \
  ttf-cascadia-code \
  tmux \
  xclip \
  zsh \

yay -S --noconfirm \
  dot-templater \
  

echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Installing tmux plugin manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm