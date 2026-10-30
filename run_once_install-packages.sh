#!/usr/bin/env bash
# chezmoi: run_once
# Bootstrap script for Ubuntu - idempotent

set -euo pipefail

# ── Directories ────────────────────────────────────────────────────────────────
mkdir -p ~/software
mkdir -p ~/projects
export PATH="$HOME/.local/bin:$HOME/.fzf/bin:$HOME/software/nvim-linux-x86_64/bin:$HOME/software/yazi-x86_64-unknown-linux-gnu/bin:$HOME/software/lazygit/bin:$PATH"

# ── APT packages ───────────────────────────────────────────────────────────────
sudo apt-get install -y \
    ca-certificates \
    curl \
    zsh \
    tmux \
    build-essential \
    zip \
    bat \
    fd-find \
    jq \
    silversearcher-ag

# ── Zellij ─────────────────────────────────────────────────────────────────────
if ! command -v zellij &>/dev/null; then
    zellij_version=0.45.1
    case "$(uname -m)" in
        x86_64) zellij_arch=x86_64-unknown-linux-musl ;;
        aarch64|arm64) zellij_arch=aarch64-unknown-linux-musl ;;
        *) echo "Unsupported architecture for Zellij: $(uname -m)" >&2; exit 1 ;;
    esac
    zellij_tmp=$(mktemp -d)
    curl -fsSL "https://github.com/zellij-org/zellij/releases/download/v${zellij_version}/zellij-${zellij_arch}.tar.gz" \
        -o "$zellij_tmp/zellij.tar.gz"
    tar -xzf "$zellij_tmp/zellij.tar.gz" -C "$zellij_tmp"
    sudo install -m 755 "$zellij_tmp/zellij" /usr/local/bin/zellij
    rm -rf "$zellij_tmp"
fi

# ── GitHub CLI ────────────────────────────────────────────────────────────────
if ! command -v gh &>/dev/null; then
    sudo install -d -m 755 /etc/apt/keyrings /etc/apt/sources.list.d
    gh_keyring=$(mktemp)
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg -o "$gh_keyring"
    sudo install -m 644 "$gh_keyring" /etc/apt/keyrings/githubcli-archive-keyring.gpg
    rm "$gh_keyring"
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt-get update -qq
    sudo apt-get install -y gh
fi

# ── chezmoi ────────────────────────────────────────────────────────────────────
if ! command -v chezmoi &>/dev/null; then
    curl -fsSL https://get.chezmoi.io | sh -s -- -b "$HOME/.local/bin"
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
if ! command -v fzf &>/dev/null; then
    if [[ ! -x ~/.fzf/install ]]; then
        fzf_tmp=$(mktemp -d)
        rm -rf ~/.fzf
        git clone --depth 1 https://github.com/junegunn/fzf.git "$fzf_tmp/fzf"
        mv "$fzf_tmp/fzf" ~/.fzf
        rm -rf "$fzf_tmp"
    fi
    if [[ ! -x ~/.fzf/bin/fzf ]]; then
        ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
    fi
fi

# ── ripgrep (latest deb) ───────────────────────────────────────────────────────
if ! command -v rg &>/dev/null; then
    curl -fsSL https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep_14.1.1-1_amd64.deb \
        -o /tmp/ripgrep.deb
    sudo dpkg -i /tmp/ripgrep.deb
    rm /tmp/ripgrep.deb
fi

# ── neovim ─────────────────────────────────────────────────────────────────────
if ! command -v nvim &>/dev/null && [[ ! -x ~/software/nvim-linux-x86_64/bin/nvim ]]; then
    nvim_archive=$(mktemp)
    curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o "$nvim_archive"
    tar -xzf "$nvim_archive" -C ~/software
    rm "$nvim_archive"
fi

# ── yazi ───────────────────────────────────────────────────────────────────────
if ! command -v yazi &>/dev/null && [[ ! -x ~/software/yazi-x86_64-unknown-linux-gnu/bin/yazi ]]; then
    yazi_tmp=$(mktemp -d)
    curl -fsSL https://github.com/sxyazi/yazi/releases/download/nightly/yazi-x86_64-unknown-linux-gnu.zip \
        -o "$yazi_tmp/yazi.zip"
    unzip -q "$yazi_tmp/yazi.zip" -d "$yazi_tmp"
    mkdir -p "$yazi_tmp/package/bin"
    mv "$yazi_tmp/yazi-x86_64-unknown-linux-gnu/ya" \
       "$yazi_tmp/yazi-x86_64-unknown-linux-gnu/yazi" \
       "$yazi_tmp/package/bin/"
    rm -rf ~/software/yazi-x86_64-unknown-linux-gnu
    mv "$yazi_tmp/package" ~/software/yazi-x86_64-unknown-linux-gnu
    rm -rf "$yazi_tmp"
fi

# ── lazygit ────────────────────────────────────────────────────────────────────
if ! command -v lazygit &>/dev/null && [[ ! -x ~/software/lazygit/bin/lazygit ]]; then
    lazygit_tmp=$(mktemp -d)
    curl -fsSL https://github.com/jesseduffield/lazygit/releases/download/v0.60.0/lazygit_0.60.0_linux_x86_64.tar.gz \
        | tar -xz -C "$lazygit_tmp"
    mkdir -p ~/software/lazygit/bin
    install -m 755 "$lazygit_tmp/lazygit" ~/software/lazygit/bin/lazygit
    rm -rf "$lazygit_tmp"
fi
if [[ -x ~/software/lazygit/bin/lazygit ]]; then
    export PATH="$HOME/software/lazygit/bin:$PATH"
fi

# ── mise ───────────────────────────────────────────────────────────────────────
if ! command -v mise &>/dev/null && [[ ! -x ~/.local/bin/mise ]]; then
    curl -fsSL https://mise.run | sh
fi

# mise: node + python
if [[ ! -x ~/.local/bin/mise ]]; then
    echo "mise installer completed without creating ~/.local/bin/mise" >&2
    exit 1
fi
if ! ~/.local/bin/mise ls --installed node | rg -q '^node@'; then
    ~/.local/bin/mise use --global node@lts
fi
if ! ~/.local/bin/mise ls --installed python | rg -q '^python@'; then
    ~/.local/bin/mise use --global python@latest
fi

# ── tmux plugin manager ────────────────────────────────────────────────────────
if [[ ! -x ~/.tmux/plugins/tpm/bin/install_plugins ]]; then
    rm -rf ~/.tmux/plugins/tpm
    mkdir -p ~/.tmux/plugins
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
