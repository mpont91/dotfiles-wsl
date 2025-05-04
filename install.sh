#!/bin/bash

echo "Installing packages..."

sudo apt update
sudo apt upgrade -y

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
    tldr \
    webp

echo "All packages installed successfully!"
