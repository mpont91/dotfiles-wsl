# ⚙️ Dotfiles WSL (windows with WSL)

This repository contains my personal dotfiles to set up and maintain a clean development environment on Windows using WSL.

## 🪟 Windows setup

### WSL installation:

Open a powershell with admin rights and run: `wsl --install`  or `wsl --update` for troubleshooting.
It will install automatically ubuntu distro which is fine.

**For the next steps, open WSL and follow the instructions.**
**Almost everything is intended to run inside WSL, otherwise will be indicated.**

### SSH Configuration (personal, required)

Create or import from bitwarden your personal ssh-key at the default path:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
```

Save the public key in your github account.

## 🚀 Installation (inside WSL)

First, clone this repository into your home directory with the default name `.dotfiles`:

```bash
git clone git@github.com:mpont91/dotfiles-wsl.git ~/.dotfiles
```

Then run the setup using the provided Makefile commands:

## 🔧 Setup Steps (inside WSL)

### 1. Install make

```bash
sudo apt install make
```

### 2. Install packages

Installs all needed.

```bash
make install
```

### 3. Create config

Links your configuration files (.zshrc, .aliases, .gitconfig, etc.) to your home directory and sets zsh as your default shell.

```bash
make config
```

This covers the personal environment — everything you need on a
personal-only machine.

## 🏢 Victoria-id setup (optional, inside WSL)

Only needed on a machine that also does victoria-id work.

### 1. SSH key

```bash
ssh-keygen -t ed25519 -f ~/.ssh/victoria-github
```

Save the public key in your victoria-id github account.

### 2. GPG signing

Victoria-id commits must be GPG-signed.

1. Create the gpg key:

   ```bash
   gpg --full-generate-key
   ```

2. To list all gpg entries

   ```bash
   gpg --list-secret-keys
   ```

3. Export public key (replace id key)

   ```bash
   gpg --armor --export AABBCCDD11223344
   ```

4. Replace gitconfig file `git/.gitconfig-victoria-id`:

   `signingkey = AABBCCDD11223344`

### 3. Link the victoria-id config

```bash
make victoria-id
```

Any repo whose remote points at `git@github.com:victoria-id/...` automatically
picks up the victoria-id git identity and SSH key, wherever it's cloned — no
particular folder needed.
