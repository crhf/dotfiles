#!/usr/bin/env bash

# nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# chezmoi
nix-env -i chezmoi
chezmoi init --apply https://github.com/crhf/dotfiles.git

# neovim
nix-env -iA nixpkgs.neovim

# zoxide
nix-env -iA nixpkgs.zoxide

# starship
nix-env -iA nixpkgs.starship

# zsh
sudo apt-get install -y zsh
chsh -s /usr/bin/zsh

# fzf
sudo apt-get install -y fzf

# pyenv
curl https://pyenv.run | bash

# npm (for pyright)
curl -L https://bit.ly/n-install | bash
n lts

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf
