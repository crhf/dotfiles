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

fzf_history_widget() {
  local selected
  selected=$(fc -rl 1 | awk '{$1=""; sub(/^ +/, ""); print}' | awk '!seen[$0]++' | fzf --height 40% --reverse --border --ansi) || return
  LBUFFER="$selected"
  zle reset-prompt
}
zle -N fzf_history_widget
bindkey '^R' fzf_history_widget

function tmux_sessionize {
  BUFFER="${ZDOTDIR}/tmux-sessionizer.sh"
  zle accept-line
}
zle -N tmux_sessionize tmux_sessionize
bindkey '^f' "tmux_sessionize"

function zellij_sessionize {
  BUFFER="${ZDOTDIR}/zellij-sessionizer.sh"
  zle accept-line
}
zle -N zellij_sessionize zellij_sessionize
bindkey '^[f' "zellij_sessionize"


function repeat_last {
  zle up-line-or-history
  zle accept-line
}
zle -N repeat_last repeat_last
bindkey '^O' "repeat_last"

function zjt {
  zellij -n "${XDG_CONFIG_HOME:-$HOME/.config}/zellij/layouts/worktree-tools.kdl" "$@"
}

function zjtab {
  "${ZDOTDIR}/zellij-switch-tab.sh" "$@"
}

function zjpane {
  "${ZDOTDIR}/zellij-switch-pane.sh" "$@"
}
