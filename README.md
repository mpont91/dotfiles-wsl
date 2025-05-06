# ⚙️ Dotfiles WSL (windows with WSL)

This repository contains my personal dotfiles to set up and maintain a clean development environment on Windows using WSL.

It includes configuration for:

- Terminal (Zsh + Oh My Zsh)
- Git
- Vim
- Editor and tool preferences
- VS Code
- Android studio

## 🪟 Windows setup

List of applications to install:

- VS Code
- Android Studio
- Brave
- PowerToys
- Microsoft Teams
- Microsoft Office
- Spotify

Install WSL:

Open a powershell and run: `wsl --install`
It will install automatically ubuntu distro which is fine.

**For the next steps, open WSL and follow the instructions.**
**Almost everything is intended to run inside WSL, otherwise will be indicated.**

## 🚀 Installation

First, clone this repository into your home directory with the default name `.dotfiles`:

```bash
git clone git@github.com:mpont91/dotfiles-wsl.git ~/.dotfiles
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

### 6. ZSH

Set default shell ZSH

```bash
make zsh
```

### 7. VS Code (Windows side)

All configurations are inside vscode folder.
Just apply them and install the extensions.

1. Apply settings: `Ctrl+Shift+P` and search for `Open User Settings (JSON)` and paste the settings.json content.

2. Apply keybindings: `Ctrl+Shift+P` and search for `Open Keyboard Shortcuts (JSON)` and paste the keybindigs.json content.

3. Create snippets: `Ctrl+Shift+P` and search for `Configure Snippets` --> `New Global Snippets file...` And paste the contents.

4. Install extensions: Go to extensions tab and install them all.

### 8. Android Studio (Windows side)

After installing the Android Studio in windows side.
Applications created with Expo tries to execute adb without extension.
So you need to create a symlink for that, as in windows the file is named as `adb.exe`

1. Run `cmd.exe` as administrator (not powershell).

2. Go to sdk platform tools, probably this path:
   `cd C:\Users\USER\AppData\Local\Android\sdk\platform-tools`

3. Create the symlink:
   `mklink adb adb.exe`
