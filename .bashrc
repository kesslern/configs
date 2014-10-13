#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias emacs='emacsclient'
PS1='[\u@\h \W]\$ '
