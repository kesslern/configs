# Source the bash_profile if it exists
if [ -f $HOME/.bash_profile ]; then
    source $HOME/.bash_profile
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(sudo tmux common-aliases archlinux history systemd)

if [ "$TERM" = "xterm" ]; then
    export TERM=xterm-256color
fi

source $ZSH/oh-my-zsh.sh

# Options should be set after sourcing oh-my-zsh.sh
command_exists () {
    type "$1" &> /dev/null ;
}

setopt hist_ignore_all_dups # Ignore duplicate history options
setopt hist_ignore_space    # Ignore commands that start with a space
unsetopt share_history      # Prevent sharing history between active sessions

# kesslern config settings
# See https://github.com/kesslern/configs/blob/master/.README.md
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias gitl=git log --pretty=format:"%h - %an, %ar : %s"

# Initiate 'thefuck'
if command_exists thefuck; then
    eval $(thefuck --alias)
fi

# Use icdiff for diff where available
if command_exists icdiff; then
    alias diff=icdiff
fi

# Add ~/.bin to the path if it exists
if [ -d "$HOME/.bin" ]; then
    export PATH=$PATH:$HOME/.bin
fi

# Alias editor commands to emacs wrapper if available
if command_exists ew; then
    alias nano=ew
    alias emacs=ew
    export EDITOR=ew
fi
