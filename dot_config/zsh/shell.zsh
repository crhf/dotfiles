setopt incappendhistory
unsetopt beep

bindkey -v
# https://coderwall.com/p/h63etq/zsh-vi-mode-no-delay-entering-normal-mode
# https://github.com/pda/dotzsh/blob/main/keyboard.zsh#L10
KEYTIMEOUT=1
bindkey -r "^L"
bindkey "^J" forward-word
bindkey "^K" forward-char
bindkey "^P" up-line-or-history
bindkey "^N" down-line-or-history
bindkey "^Y" accept-line

function tmux_sessionize {
  BUFFER="${ZDOTDIR}/tmux-sessionizer.sh"
  zle accept-line
}
zle -N tmux_sessionize tmux_sessionize
bindkey '^f' "tmux_sessionize"


function repeat_last {
  zle up-line-or-history
  zle accept-line
}
zle -N repeat_last repeat_last
bindkey '^O' "repeat_last"
