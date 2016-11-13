if [ -f $HOME/.bash_profile ]; then
    source $HOME/.bash_profile
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(sudo tmux common-aliases)

if [ "$TERM" = "xterm" ]; then
    export TERM=xterm-256color
fi

source $ZSH/oh-my-zsh.sh

# Options should be set after sourcing oh-my-zsh.sh

command_exists () {
    type "$1" &> /dev/null ;
}

setopt hist_ignore_all_dups
unsetopt share_history

alias emacs=emacsclient -nw
alias nano=emacsclient -nw
alias e=emacsclient -nw
alias gitl=git log --pretty=format:"%h - %an, %ar : %s"
export EDITOR='emacsclient -nw'

# kesslern config settings
# See https://github.com/kesslern/configs/blob/master/.README.md
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Initiate 'thefuck'
if command_exists thefuck; then
    eval $(thefuck --alias)
fi
