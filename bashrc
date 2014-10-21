#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias emacs='emacsclient -nw'
PS1='[\u@\h \W]\$ '
