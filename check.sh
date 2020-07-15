#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 [TEMPLATE]"
fi

if [ ! -f "$1" ]; then
  echo "Template \"$1\" does not exist."
  exit 1
fi

mkdir -p ~/.dotfiles
dot-templater --diff "$1" dotfiles ~/.dotfiles
