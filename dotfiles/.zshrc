# Add ~/.bin to the path if it exists
if [ -d "$HOME/.bin" ]; then
    export PATH=$PATH:$HOME/.bin
fi

# Add ~/.local/bin to the path if it exists
if [ -d "$HOME/.local/bin" ]; then
    export PATH=$PATH:$HOME/.local/bin
fi

# Add ~/.cargo/bin to the path if it exists
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH=$PATH:$HOME/.cargo/bin
fi

# Add ~/.templates to the path if it exists
if [ -d "$HOME/.templates" ]; then
    export PATH=$PATH:$HOME/.templates
fi

# Add ~/go/bin to the path if it exists
if [ -d "$HOME/go/bin" ]; then
    export PATH=$PATH:$HOME/go/bin
fi

# Source the bash_profile if it exists
if [ -f $HOME/.bash_profile ]; then
    source $HOME/.bash_profile
fi

if [ -f $HOME/.cargo/bin ]; then
    source $HOME/.cargo/bin
fi

# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(
        archlinux
        common-aliases
        dirhistory
        docker
        fzf
        gitfast
        gradle
        history
        httpie
        npm
        sudo
        systemd
        yarn
)

if [ "$TERM" = "xterm" ]; then
    export TERM=xterm-256color
fi

[ -f /etc/profile.d/autojump.zsh ] && source /etc/profile.d/autojump.zsh
source $HOME/.zsh/plugins/bd.zsh
source $ZSH/oh-my-zsh.sh

# Options should be set after sourcing oh-my-zsh.sh

command_exists () {
    type "$1" &> /dev/null ;
}

setopt hist_ignore_all_dups # Ignore duplicate history options
setopt hist_ignore_space    # Ignore commands that start with a space
unsetopt share_history      # Prevent sharing history between active sessions

# Increase zsh history length
export SAVEHIST=50000

# Dircolors settings
if command_exists dircolors; then
    eval `dircolors $HOME/.dircolors`
elif command_exists gdircolors; then
    eval `gdircolors $HOME/.dircolors`
fi

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Initiate 'thefuck'
if command_exists thefuck; then
    eval $(thefuck --alias)
fi

# Use icdiff for diff where available
if command_exists icdiff; then
    alias diff=icdiff
fi

# Use icdiff for diff where available
if command_exists exa; then
    alias e=exa
fi

# Source gcloud autocompletes if they exist
if [ -d "/opt/google-cloud-sdk/completion.zsh.inc" ]; then
    source /opt/google-cloud-sdk/completion.zsh.inc
fi

# Alias editor commands to emacs wrapper if available
if command_exists ew; then
    alias nano=ew
    alias emacs=ew
    export EDITOR=ew
fi

# Aliases to format pretty-print JSON and XML
alias -g JSON='| python -m json.tool'
alias -g XML='| xmllint --format -'

# Copy and paste
if command_exists xclip; then
    COPY='xclip -selection clipboard'
    PASTE='xclip -selection clipboard -o'
else
    COPY='pbcopy'
    PASTE='pbpaste'
fi

alias -g paste="$PASTE"
alias -g copy="$COPY"
alias -g COPY="| $COPY"

alias -g npm="nocorrect npm"

if command_exists lesspipe.sh; then
    export LESSOPEN="|lesspipe.sh %s"
fi

if ! command_exists open; then
   alias open="xdg-open"
fi

if [ -e /usr/share/nvm/init-nvm.sh ]; then
    source /usr/share/nvm/init-nvm.sh
fi

if [ -e /usr/bin/kubectl ]; then
    source <(kubectl completion zsh)
fi

swap_files() {
    if [ $# -ne 2 ]; then
        echo "Usage: swap_files file1 file2"
        return 1
    fi

    tmpfile=$(mktemp $(dirname "$1")/XXXXXX)
    mv "$1" "$tmpfile" && mv "$2" "$1" && mv "$tmpfile" "$2"
}

alias nps="cat package.json|jq .scripts"
