# Setup fzf
# ---------
export FZF_DEFAULT_OPTS="-e --no-sort"

if [[ ! "$PATH" == */home/jb55/.fzf/bin* ]]; then
  export PATH="$PATH:/home/jb55/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/jb55/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/jb55/.fzf/shell/key-bindings.zsh"

