# ⚙️ Dotfiles WSL (windows with WSL)

This repository contains my personal dotfiles to set up and maintain a clean development environment on Windows using WSL.

## 🪟 Windows setup

### WSL installation:

Open a powershell with admin rights and run: `wsl --install`  or `wsl --update` for troubleshooting.
It will install automatically ubuntu distro which is fine.

**For the next steps, open WSL and follow the instructions.**
**Almost everything is intended to run inside WSL, otherwise will be indicated.**

### SSH Configuration (only personal environment)

Create or import from bitwarden your personal ssh-key at the default path:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
```

Save the public key in your github account.

### SSH Configuration (Personal, PresentConnection and Victoria-id all together)

On top of the default personal key above, create the work-specific keys:

```bash
ssh-keygen -t rsa -f ~/.ssh/pc-bitbucket
ssh-keygen -t rsa -f ~/.ssh/victoria-github
```

Save the public keys in github and bitbucket accounts.

Then with the script to link dotfiles will be automatically configured to use both keys.

#### GPG configuration (only for Victoria-ID)

For Victoria-id is needed to have gpg signed commits.

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

Links your configuration files (.zshrc, .aliases, .gitconfig, etc.) to your home directory.

```bash
make config
```

### 4. ZSH

Set default shell ZSH

```bash
make zsh
```

### 5. Projects structure

Creates `~/projects`. For a personal-only machine, your projects live directly
inside it (no subfolder needed — the personal git identity is the default, so
it applies regardless), and this is all you need:

```bash
make projects
```

Later, on a machine that also needs PresentConnection/Victoria-id (see the SSH
and GPG setup above), add those contexts on top. This also adds a `personal/`
subfolder so all three sit side by side for organization — existing repos
directly under `~/projects` are **not** moved automatically, move them into
`personal/` yourself if you want. Each subfolder matches an `includeIf` rule in
`.gitconfig` (personal doesn't need one, it's just the default), so repos
cloned inside `present-connection/` or `victoria-id/` automatically get the
right git identity/SSH key. Existing folders are left untouched.

```bash
make projects-full
```
