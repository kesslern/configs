# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo tmux common-aliases lein)

ZSH_TMUX_FIXTERM_WITHOUT_256COLOR="true"
ZSH_TMUX_FIXTERM_WITH_256COLOR="true"

if [ "$TERM" = "xterm" ]; then
    export TERM=xterm-256color
fi

source $ZSH/oh-my-zsh.sh

# Options should be set after sourcing oh-my-zsh.sh

setopt hist_ignore_all_dups
unsetopt share_history

alias emacs=emacsclient -nw
alias nano=emacsclient -nw
alias e=emacsclient -nw
alias gitl=git log --pretty=format:"%h - %an, %ar : %s"
export EDITOR='emacsclient -nw'

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

export SDKMAN_DIR="/Users/kesslern/.sdkman"
[[ -s "/Users/kesslern/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/kesslern/.sdkman/bin/sdkman-init.sh"

eval $(thefuck --alias)
