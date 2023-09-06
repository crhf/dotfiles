# rust cargo (before zoxide)
export PATH=$PATH:$HOME/.cargo/bin

# zoxide
eval "$(zoxide init zsh)"

# starship
eval "$(starship init zsh)"

# erg
export PATH=$PATH:/home/crhf/.erg/bin
export ERG_PATH=/home/crhf/.erg

# Leetgo
export LEETCODE_USERNAME=crhf
export LEETCODE_PASSWORD=lDitto\!c12

# sdkman
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# virtualenv wrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
alias mkvv='mkvirtualenv'
alias lsvv='lsvirtualenv'
alias showvv='showvirtualenv'
alias rmvv='rmvirtualenv'
alias cpvv='cpvirtualenv'
alias allvv='allvirtualenv'
alias wo='workon'
alias da='deactivate'

# software
export PATH=$PATH:$(ls -d $HOME/software/*/bin | paste -sd:)

# Go
export PATH=$PATH:$HOME/go/bin
export PATH=$HOME/.local/share/go/bin:$PATH
export GOPATH=$HOME/.local/share/go

# fnm
# eval "$(fnm env --use-on-cd)"

# ARDiff
export LD_LIBRARY_PATH=/home/crhf/projects/pendulum/ARDiff/Implementation/jpf-git/jpf-symbc/lib

# underscore
alias us='underscore'

# leetgo
alias lo='leetgo'

# lazygit
alias lg='lazygit'

# zellij
alias zj='zellij'
