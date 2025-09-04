# rust cargo (before zoxide)
export PATH=$PATH:$HOME/.cargo/bin

# nix must come before starship & zoxide
. ~/.nix-profile/etc/profile.d/nix.sh

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
alias mkvv='mkvirtualenv'
alias lsvv='lsvirtualenv'
alias showvv='showvirtualenv'
alias rmvv='rmvirtualenv'
alias cpvv='cpvirtualenv'
alias allvv='allvirtualenv'
alias wo='workon'
alias da='deactivate'

# software
export PATH=$PATH:$(find $HOME/software/ -maxdepth 2 -name bin -type d | paste -sd:)

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

# pyenv and pyenv-virtualenv

# Load pyenv automatically by appending
# the following to
# ~/.bash_profile if it exists, otherwise ~/.profile (for login shells)
# and ~/.bashrc (for interactive shells) :

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Restart your shell for the changes to take effect.

# Load pyenv-virtualenv automatically by adding
# the following to ~/.bashrc:

eval "$(pyenv virtualenv-init -)"

alias lzd=lazydocker
