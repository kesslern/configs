#!/bin/bash

echo "Installing dependencies..."
sudo pacman -S --noconfirm \
  adobe-source-code-pro-fonts \
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
  noto-fonts-emoji \
  tmux \
  xclip \
  zsh \
|| exit 1

yay -S --noconfirm \
  dot-templater \
  ttf-nanum \
|| exit 1

echo "Installing oh-my-zsh..."
if [ -e ~/.oh-my-zsh ]; then
  echo "oh-my-zsh already installed. Skipping..."
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
  || exit 1
fi

echo "Installing tmux plugin manager..."
if [ -e ~/.tmux/plugins/tpm ]; then
  echo "tmux plugin manager already installed. Skipping..."
else
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
  || exit 1
fi

echo "Installing spacemacs"
if [ -e ~/.emacs.d/init.el ]; then
  echo "spacemacs already installed. Skipping..." 
else
  git clone --depth 1 https://github.com/syl20bnr/spacemacs ~/.emacs.d \
  || exit 1
fi
