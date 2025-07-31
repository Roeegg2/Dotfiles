#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
. "$HOME/.cargo/env"

# Making Vi bindings
set -o vi

alias start='sway --unsupported-gpu'

# Created by `pipx` on 2025-07-30 10:09:46
export PATH="$PATH:/home/roeet/.local/bin"
