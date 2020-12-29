# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
set -o vi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export PS1='$(printf "\n\033[30;1m%3.*s\033[0m$ \033[33m" $? $?)'
export PS0='\033[0m'

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

DIRCOLORS="$HOME/.dircolors"
UNDISTRACT="$HOME/dotfiles/bash-undistract-me/undistract-me.sh"

bind 

[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -e "$DIRCOLORS" ] && eval "$(dircolors -b "$DIRCOLORS")"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/bin/z.sh ] && source ~/bin/z.sh
[ -f "$UNDISTRACT" ] && source "$UNDISTRACT"

eval "$(direnv hook bash)"

# needed for the C-h binding
bind '"\C-x\C-a": vi-movement-mode'
bind '"\C-x\C-e": shell-expand-line'
bind '"\C-x\C-r": redraw-current-line'
bind '"\C-x^": history-expand-line'

bind '"\C-f": "\C-x\C-addi`fuzz-run-command`\C-x\C-e\C-x^\C-x\C-a$a\C-x\C-r"'
bind -m vi-command '"\C-f": "i\C-f"'
bind '"\C-h": "\C-x\C-addi`fuzz-run-command sh`\C-x\C-e\C-x^\C-x\C-a$a\C-x\C-r"'
bind -m vi-command '"\C-h": "i\C-h"'
bind '"\C-l":clear-screen'
