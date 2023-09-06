setopt incappendhistory

bindkey -v
bindkey -r "^L"
bindkey "^J" forward-word
bindkey "^K" forward-char
bindkey "^P" up-line-or-history
bindkey "^N" down-line-or-history

function tmux_sessionize {
  BUFFER="/home/crhf/dotfiles/tmux-sessionizer.sh"
  zle accept-line
}
zle -N tmux_sessionize tmux_sessionize
bindkey '^f' "tmux_sessionize"
