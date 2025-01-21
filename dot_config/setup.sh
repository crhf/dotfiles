#!/usr/bin/env bash

# nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# chezmoi
nix-env -i chezmoi
chezmoi init --apply https://github.com/crhf/dotfiles.git

# neovim
nix-env -iA nixpkgs.neovim
sudo apt-get install -y ripgrep

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

# python3-venv, for ruff etc.
sudo apt-get install -y python3-venv

# brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# lazygit
nix-env -iA nixpkgs.lazygit

# lazydocker
brew install jesseduffield/lazydocker/lazydocker

# gnome extensions
  # workspace-switcher-manager@G-dH.github.com
  # space-bar@luchrioh
  # user-theme@gnome-shell-extensions.gcampax.github.com
  # stopwatch@aliakseiz.github.com
  # cosmic-dock@system76.com
  # cosmic-workspaces@system76.com
  # ding@rastersoft.com
  # pop-cosmic@system76.com
  # pop-shell@system76.com
  # popx11gestures@system76.com
  # system76-power@system76.com
  # ubuntu-appindicators@ubuntu.com

