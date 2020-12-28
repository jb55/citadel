#
# Path to your oh-my-zsh configuration.
#export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
#export ZSH_THEME="jb55"

#export DISABLE_AUTO_UPDATE="true"
#source $ZSH/oh-my-zsh.sh

# vi
bindkey -v

setopt HIST_IGNORE_SPACE
setopt AUTO_PUSHD
setopt PUSHD_MINUS
setopt CDABLE_VARS
zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'

# short ESC delay
export KEYTIMEOUT=1

bindkey "^R" history-incremental-search-backward

# history settings
export HISTSIZE=50000
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups

# fix ssh agent forwarding in screen
FIXSSH=$HOME/bin/fixssh
if [[ $TERM == screen* ]] && [[ -f $FIXSSH ]]; then
  source $FIXSSH
fi

source "$HOME/bin/z.sh"

ALIASES="$HOME/.bash_aliases"
[ -e "$ALIASES" ] && source "$ALIASES"

runthefuzzyo_hist () { f h }
runthefuzzyo () { f "$@" }
zle -N runthefuzzyo
zle -N runthefuzzyo_hist
bindkey "^F" runthefuzzyo
bindkey "^H" runthefuzzyo_hist

DIRCOLORS="$HOME/.dircolors"
[ -e "$DIRCOLORS" ] && eval "$(dircolors -b "$DIRCOLORS")"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '

# undistract-me is great
[ -e $HOME/dotfiles/zsh/undistract-me.zsh ] && . $HOME/dotfiles/zsh/undistract-me.zsh

eval "$(direnv hook zsh)"
