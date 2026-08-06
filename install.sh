#!/bin/bash

echo "Configuring repositories..."

sudo apt update
sudo apt install -y curl ca-certificates

if [ ! -f /etc/apt/keyrings/docker.asc ]; then
    echo "Adding Docker GPG key and repository..."
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

echo "Updating and upgrading system packages..."
sudo apt update
sudo apt upgrade -y

echo "Installing all required packages..."
sudo apt install -y \
    zsh \
    build-essential \
    wget \
    curl \
    git \
    vim \
    htop \
    tree \
    openssh-client \
    imagemagick \
    webp \
    sqlite3 \
    gh \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python3-openssl \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo "Configuring Docker permissions..."
sudo usermod -aG docker $USER

echo "All packages installed successfully!"

echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "Oh My Zsh installed successfully!"
else
    echo "Oh My Zsh is already installed. Skipping."
fi

echo "Installing Oh My Zsh plugins..."
OHMYZSH_PLUGINS_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins
mkdir -p "$OHMYZSH_PLUGINS_CUSTOM"

if [ ! -d "$OHMYZSH_PLUGINS_CUSTOM/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$OHMYZSH_PLUGINS_CUSTOM/zsh-autosuggestions"
else
    echo "zsh-autosuggestions is already installed. Skipping."
fi

if [ ! -d "$OHMYZSH_PLUGINS_CUSTOM/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$OHMYZSH_PLUGINS_CUSTOM/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting is already installed. Skipping."
fi
echo "Oh My Zsh plugins installation finished."

echo "Installing NVM (Node Version Manager)..."
if [ ! -d "$HOME/.nvm" ]; then
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
    echo "NVM installed successfully!"
else
    echo "NVM is already installed. Skipping."
fi

echo "Installing pyenv..."
if [ ! -d "$HOME/.pyenv" ]; then
    curl https://pyenv.run | bash
    echo "pyenv installed successfully!"
else
    echo "pyenv is already installed. Skipping."
fi

echo "Installing Claude..."
if ! command -v claude &> /dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
    echo "Claude installed successfully!"
else
    echo "Claude is already installed. Skipping."
fi

echo "🚀 Dotfiles installation completed successfully! Remember to restart your terminal for Docker permissions to take effect."