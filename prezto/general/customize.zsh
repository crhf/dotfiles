#-- Aliases -------------------------------------------------------------------
# Proxy
alias setproxy="export ALL_PROXY=socks://127.0.0.1:10808"
alias unsetproxy="unset ALL_PROXY"

# z.lua
alias zz='z -c'      # restrict matches to subdirs of $PWD
alias zi='z -i'      # cd with interactive selection
alias zf='z -I'      # use fzf to select in multiple matches
alias zb='z -b'      # quickly cd to the parent directory

# ssh
alias ssh='ssh -o ServerAliveInterval=60'

# clear
alias c='clear'

# git
alias ga='git add -A'
alias gc='git commit -m'
alias gp='git push'

#-- Locale --------------------------------------------------------------------
export LC_ALL=C.UTF-8
export TERM=xterm-256color

#-- Shell Options -------------------------------------------------------------
setopt noEXTENDED_GLOB
