# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
set -o vi

export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export NIXPKGS=$HOME/nixpkgs
export NIX_PATH="nixpkgs=$NIXPKGS:$NIX_PATH"
export NIX_PATH="nixos-config=$NIX_FILES:$NIX_PATH"
export NIX_PATH="jb55pkgs=$HOME/etc/jb55pkgs:$NIX_PATH"
export NIX_PATH="dotfiles=$HOME/dotfiles:$NIX_PATH"

# If not running interactively, don't do anything
#[ -z "$PS1" ] && return

export HOST=$(hostname)
export IGNORE_WINDOW_CHECK=1
export LONG_RUNNING_COMMAND_TIMEOUT=3
IN_NIX=""
if [ -n "$IN_NIX_SHELL" ]; then
	IN_NIX="-nix"
fi
export PS1='$(printf "\x01\033[30;1m\x02%3.*s\x01\033[0m\x02 %s%s> \x01\033[33m\x02" $? $? $HOST $IN_NIX)'
export PS0='\033[0m'

#export PS1='$(printf "\x01\033[30;1m\x02%3.*s\x01\033[0m\x02> " $? $?)'

# don't put duplicate lines in the history. See bash(1) for more options
#export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=50000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# OMG
shopt -s histappend

DIRCOLORS="$HOME/.dircolors"
UNDISTRACT="$HOME/dotfiles/bash-undistract-me/undistract-me.sh"

export PAGER="less"
export LESS="-cix8RM --save-marks"

TERM_THEME="dark"
if [ -f ~/.Xresources.d/themes/current ]; then
	TERM_THEME="$(basename $(readlink ~/.Xresources.d/themes/current))"
fi

# private stuff
. ~/.bash_private

if [ "$TERM_THEME" == "light" ]
then
	export BAT_THEME=GitHub
else
	export BAT_THEME=zenburn
fi

export NNCPCFG=~/.nncprc
export PANDOC=pandoc-nice
export MAIL=/home/jb55/var/notify/email-notify
export MAILREADER=/run/current-system/sw/bin/neomutt
export BAT_STYLE=plain
export LPASS_HOME="$HOME/.config/lpass"
export FUZZER=fzf
export GOPHERCLIENT=vf1
export GEMINICLIENT=av98
export GOPHER=$GOPHERCLIENT
export GNUPGHOME="$HOME/.gnupg"
export SHAREFILE_HOST='charon:/www/cdn.jb55.com/s/'
export SHAREFILE_URL='https://cdn.jb55.com/s/'
export SHARE_SS_DIR="$HOME/var/img/ss"
export DOTFILES=${DOTFILES:-$HOME/dotfiles}
export VI_MODE=1
export XZ=pxz
export FZF_CTRL_R_OPTS="-e"
export FZF_DEFAULT_OPTS="-e"
export FZF_DEFAULT_COMMAND='rg --files --hidden'
export EMACSCLIENT=edit

# other
export EDITOR="edit"
export VISUAL="edit"
export BROWSER="browser"
export PAGER=less

# go

export GOPATH=$HOME/dev/gocode
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.npm/bin:$PATH
export PATH=$GOPATH/bin:$PATH

md () {
    mandown README*
}

function f() {
	eval "$(fuzz-run-command "$@")"
}

alias ag="ag --pager=less"
alias attach="grabssh; screen -rD"
alias awkt="awk -v FS=$'\t' -v OFS=$'\t'"
alias catt="pygmentize -O style=monokai -f console256 -g"
alias Ci="pcal interactive"
alias clip="xclip -selection clipboard"
alias C="pcal list"
alias cpptags="ctags -R --sort=1 --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++"
alias crontab="VIM_CRONTAB=true crontab"
alias cutt="cut -d $'\t' --output-delimiter=$'\t'"
alias e="edit -n"
alias emacs="env TERM=xterm-256color emacs"
alias feh="feh --conversion-timeout 2"
alias fixssh="source $HOME/bin/fixssh"
#alias f=run_fuzzer
alias fzf="fzf --exact"
alias g=git
alias githist="git reflog show | grep '}: commit' | nl | sort -nr | nl | sort -nr | cut --fields=1,3 | sed s/commit://g | sed -e 's/HEAD*@{[0-9]*}://g'"
alias ibmgfx="cp437"
alias info="info --vi-keys"
alias jc="journalctl -u"
alias jcu="journalctl --user -u"
alias jsonpp="python -mjson.tool"
alias ls="ls --color"
alias m="neomutt"
alias mq="msmtp-queue"
alias mt="f nt query:today"
alias myipaddress=myip
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias noder="env NODE_NO_READLINE=1 rlwrap node"
alias nr="npm run"
alias ns="nix-shell -p"
alias page=$PAGER
alias prettyjson=jsonpp
alias qud="steam-run ~/.local/share/Steam/steamapps/common/Caves\ of\ Qud/CoQ.x86_64"
alias scs="systemctl status"
alias scsu="systemctl status --user"
alias s="general-status"
alias sorry='sudo $(fc -l -n -1)'
alias tmuxa="tmux a -d -t "
alias tmux="tmux -2"
alias t="todo.sh"
alias u="cd .."
alias vim=nvim
alias vless="/usr/share/vim/vim72/macros/less.sh"
alias vnc_once="x11vnc -safer -nopw -once -display :0"
alias wanip=myip
alias wget="wget -c"
alias xclip="xclip -selection clipboard"

ghclone () {
  cd "$(gh-clone "$@")"
}

srhtclone () {
  cd "$(srht-clone "$@")"
}

cdnp () {
  nix-build '<nixpkgs>' --no-out-link -A "$1"
  cd $(nix-path "$1")
}

np () {
  nix-path "$1"
}

nsr () {
  local cmd="$1"
  shift
  nix-shell -p "$cmd" --run "$@"
}

nsr2 () {
    local cmd="$1"
    shift
    local cmd2="$(<<<"$cmd" rev | cut -d. -f1 | rev) $@"
    nsr "$cmd" "$cmd2"
}

nsc () {
  local cmd="$1"
  shift
  nix-shell -p "$cmd" --command "$@"
}

share () {
  sharefile "$@" | xclip
}

sharess () {
  share_last_ss | xclip
}

lt () {
  ls -ltah "$@" | "$PAGER"
}

lt1 () {
  res=$(\ls -1 -t "$@" | head -n1)
  xclip <<<"$res"
  printf '%s\n' "$res"
}

mv1 () {
  mv $(lt1 | stripansi) "$@"
}

pcsv () {
  csv-delim "$@" | pcsvt
}

pcsvt () {
  columnt "$@" | cat -n | less -R -S
}

header() {
  headers "${2:-/dev/stdin}" | grep "$1" | cutt -f1 | sed -E 's,^[ ]*,,g'
}

nsum() {
  awkt '{total = total + $1}END{print total}'
}

sumcol() {
  cut -f "$1" | nsum
}

uniqc() {
  sort "$@" | uniq -c | sort -nr
}

cdl () {
  cd "$(dirname "$(readlink -f "$(which "$1")")")"
}

env-type () {
  envtype="$1"
  shift
  nix-shell -Q -p $envtype "$@"
}

haskell-env () {
  env-type "haskellEnv" "$@"
}

haskell-env-hoogle () {
  env-type "haskellEnvHoogle" "$@"
}

haskell-env-tools() {
  env-type "haskellTools" "$@"
}

build-nix-cache() {
  nix-env -f "$NIXPKGS" -qaP \* > ~/.nixenv.cache
}

haskell-shell() {
  nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [$*])"
}

nix-path() {
  nix-instantiate --eval --expr 'with import <nixpkgs> {}; "${'"$1"'}"' | sed 's/"//g'
}

vnc-once() {
  x11vnc -safer -nopw -once -display ':0' "$1"
}

sql_wineparty() {
  export CS='postgres://wineparty.xyz/wineparty'
  export PG_USER='jb55'
}

sql_() {
  local query="$1"
  local args=("-U" "$pg_user" -A)
  if [ ! -z "$query" ];
  then
    args+=(-c "$query")
  fi
  psql -F $'\t' "${args[@]}"
}

sql() {
  sql_ "$@" -t | pcsvt
}

# fzf
source $DOTFILES/.fzf_helpers

# z
source $HOME/bin/z.sh

[ -e "$DIRCOLORS" ] && eval "$(dircolors -b "$DIRCOLORS")"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/bin/z.sh ] && source ~/bin/z.sh
[ -f "$UNDISTRACT" ] && source "$UNDISTRACT"

eval "$(/run/current-system/sw/bin/direnv hook bash)"

# needed for the C-h binding
bind '"\C-x\C-a": vi-movement-mode'
bind '"\C-x\C-e": shell-expand-line'
bind '"\C-x\C-r": redraw-current-line'
bind '"\C-x^": history-expand-line'

bind '"\C-f": "`fuzz-run-command`\C-x\C-e"'
bind -m vi-command '"\C-f": "i\C-f"'
bind '"\C-g": "`fuzz-run-command sh`\C-x\C-e"'
bind -m vi-command '"\C-h": "i\C-h"'
bind '"\C-e": "!!\C-x\C-e"'
bind -m vi-command '"\C-e": "i\C-e"'
bind '"\C-l":clear-screen'


