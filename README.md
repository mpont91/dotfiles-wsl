# ⚙️ Dotfiles

This repository contains my personal dotfiles to set up and maintain a clean development environment on Linux OS.

It includes configuration for:

- Terminal (Zsh + Oh My Zsh)
- Git
- Vim
- Editor and tool preferences

## 🚀 Installation

First, clone this repository into your home directory with the default name `.dotfiles`:

```bash
git clone git@github.com:mpont91/dotfiles-linux.git ~/.dotfiles
```

Then run the setup using the provided Makefile commands:

## 🔧 Setup Steps

### 1. Install make

```bash
sudo apt install make
```

### 2. Install packages

Installs all packages needed.

```bash
make install
```

### 3. Install NVM

Installs NVM

```bash
make nvm
```

### 4. Install Oh My Zsh

Installs Oh My Zsh (only if not already present) without modifying .zshrc.

```bash
make ohmyzsh
```

### 5. Create symlinks

Links your configuration files (.zshrc, .aliases, .vimrc, .gitconfig, etc.) to your home directory.

```bash
make link
```