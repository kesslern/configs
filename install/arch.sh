#!/bin/bash

echo "Installing dependencies..."
sudo pacman -S --noconfirm \
  adobe-source-code-pro-fonts \
  emacs \
  eza \
  fzf \
  lesspipe \
  libxml2 \
  noto-fonts-emoji \
  python \
  tmux \
  ttf-cascadia-code \
  xclip \
  zoxide \
  zsh \
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

systemctl enable --user emacs
systemctl start --user emacs
