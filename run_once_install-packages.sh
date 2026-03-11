#!/usr/bin/env bash
# chezmoi: run_once
# Bootstrap script for Ubuntu - idempotent

set -euo pipefail

# ── Directories ────────────────────────────────────────────────────────────────
mkdir -p ~/software
mkdir -p ~/projects

# ── APT packages ───────────────────────────────────────────────────────────────
sudo apt-get update -qq
sudo apt-get install -y \
    zsh \
    tmux \
    build-essential \
    zip \
    bat \
    fd-find \
    jq \
    silversearcher-ag

# ── chezmoi ────────────────────────────────────────────────────────────────────
if ! command -v chezmoi &>/dev/null; then
    curl -fsSL https://get.chezmoi.io | sh
fi

# ── starship ───────────────────────────────────────────────────────────────────
if ! command -v starship &>/dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

# ── zoxide ─────────────────────────────────────────────────────────────────────
if ! command -v zoxide &>/dev/null; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# ── fzf ────────────────────────────────────────────────────────────────────────
if [[ ! -d ~/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# ── ripgrep (latest deb) ───────────────────────────────────────────────────────
if ! command -v rg &>/dev/null; then
    curl -fsSL https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep_14.1.1-1_amd64.deb \
        -o /tmp/ripgrep.deb
    sudo dpkg -i /tmp/ripgrep.deb
    rm /tmp/ripgrep.deb
fi

# ── neovim ─────────────────────────────────────────────────────────────────────
if [[ ! -d ~/software/nvim-linux-x86_64 ]]; then
    curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
        | tar -xz -C ~/software
fi

# ── yazi ───────────────────────────────────────────────────────────────────────
if [[ ! -d ~/software/yazi-x86_64-unknown-linux-gnu ]]; then
    curl -fsSL https://github.com/sxyazi/yazi/releases/download/nightly/yazi-x86_64-unknown-linux-gnu.zip \
        -o /tmp/yazi.zip
    unzip /tmp/yazi.zip -d ~/software
    mkdir -p ~/software/yazi-x86_64-unknown-linux-gnu/bin
    mv ~/software/yazi-x86_64-unknown-linux-gnu/ya \
       ~/software/yazi-x86_64-unknown-linux-gnu/yazi \
       ~/software/yazi-x86_64-unknown-linux-gnu/bin/
    rm /tmp/yazi.zip
fi

# ── lazygit ────────────────────────────────────────────────────────────────────
if ! command -v lazygit &>/dev/null; then
    mkdir -p ~/software/lazygit
    curl -fsSL https://github.com/jesseduffield/lazygit/releases/download/v0.60.0/lazygit_0.60.0_linux_x86_64.tar.gz \
        | tar -xz -C ~/software/lazygit
    mkdir -p ~/software/lazygit/bin
    mv ~/software/lazygit/lazygit ~/software/lazygit/bin/
fi

# ── mise ───────────────────────────────────────────────────────────────────────
if ! command -v mise &>/dev/null && [[ ! -f ~/.local/bin/mise ]]; then
    curl -fsSL https://mise.run | sh
fi

# mise: node + python
~/.local/bin/mise use --global node@lts
~/.local/bin/mise use --global python@latest

# ── tmux plugin manager ────────────────────────────────────────────────────────
if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# ── docker ─────────────────────────────────────────────────────────────────────
if ! command -v docker &>/dev/null; then
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sudo sh /tmp/get-docker.sh
    rm /tmp/get-docker.sh
fi
sudo usermod -aG docker "$USER"

# ── Claude Code ────────────────────────────────────────────────────────────────
if ! command -v claude &>/dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
fi

# ── Default shell: zsh ─────────────────────────────────────────────────────────
if [[ "$SHELL" != "$(which zsh)" ]] && command -v zsh &>/dev/null; then
    chsh -s "$(which zsh)"
fi

git config --global user.name crhf
git config --global user.email hruan.dev@gmail.com

echo "✅ Bootstrap complete. Please log out and back in for docker group and shell changes to take effect."
