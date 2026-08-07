#!/bin/bash

echo "Installing dependencies..."
sudo dnf install -y \
  adobe-source-code-pro-fonts \
  emacs \
  fzf \
  libxml2 \
  google-noto-emoji-fonts \
  nodejs \
  npm \
  python3 \
  python3-python-lsp-server \
  rust \
  cargo \
  rust-analyzer \
  tmux \
  cascadia-code-fonts \
  xclip \
  zsh \
|| exit 1

echo "Installing npm-only language servers..."
npm install -g typescript-language-server vscode-langservers-extracted || exit 1

echo "Installing oh-my-zsh..."
if [ -e ~/.oh-my-zsh ]; then
  echo "oh-my-zsh already installed. Skipping..."
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
  || exit 1
fi

echo "Installing tmux plugin manager..."
if [ -e ~/.tmux/plugins/tpm ]; then
  echo "tmux plugin manager already installed. Skipping..."
else
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
  || exit 1
fi

systemctl --user enable emacs
systemctl --user start emacs
