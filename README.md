# ⚙️ Dotfiles WSL (windows with WSL)

This repository contains my personal dotfiles to set up and maintain a clean development environment on Windows using WSL.

## WSL installation:

Open a powershell with admin rights and run: `wsl --install`  or `wsl --update` for troubleshooting.
It will install automatically ubuntu distro which is fine.

## SSH Configuration

Restore `~/.ssh/id_ed25519` from password manager.

<details>
<summary>First time only — no existing key to restore yet</summary>

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
```

Save the public key in your github account, then back it up to your password
manager so you never have to generate it again.

</details>

## Installation

Clone this repository into your home directory with the default name `.dotfiles`:

```bash
git clone git@github.com:mpont91/dotfiles-wsl.git ~/.dotfiles
```

### 0. Install make in case you don't have it

```bash
sudo apt install make
```

### 1. Install packages

Installs all needed.

```bash
make install
```

### 2. Apply configuration

Links your configuration files (.zshrc, .aliases, .gitconfig, etc.) to your home directory and sets zsh as your default shell.

```bash
make config
```

This covers the personal environment — everything you need on a
personal-only machine.

## 🏢 Victoria-id setup

`make config` already links `git/.gitconfig-victoria-id` — it just sits
dormant until a repo's remote actually matches victoria-id. Only needed on a
machine that also does victoria-id work: the two keys below.

### 1. SSH key

Restore `~/.ssh/victoria-github` from password manager.

<details>
<summary>First time only — no existing key to restore yet</summary>

```bash
ssh-keygen -t ed25519 -f ~/.ssh/victoria-github
```

Save the public key in your victoria-id github account, then back it up to
your password manager so you never have to generate it again.

</details>

### 2. GPG signing

Victoria-id commits must be GPG-signed. Restore the key from the password manager, then delete the file:

```bash
gpg --import victoria-id-gpg-private.asc
rm victoria-id-gpg-private.asc
```

The fingerprint doesn't change on import, so the `signingkey` already in
`git/.gitconfig-victoria-id` keeps working without editing anything.

<details>
<summary>First time only — no existing key to restore yet</summary>

```bash
gpg --full-generate-key
gpg --list-secret-keys
```

Put the fingerprint as `signingkey` in `git/.gitconfig-victoria-id`, add the
public key (`gpg --armor --export <fingerprint>`) to your victoria-id github
account, then back up the private key so you never have to do this again:

```bash
gpg --export-secret-keys --armor <fingerprint> > victoria-id-gpg-private.asc
cat victoria-id-gpg-private.asc
```

Copy everything printed, from `-----BEGIN PGP PRIVATE KEY BLOCK-----` to
`-----END PGP PRIVATE KEY BLOCK-----` inclusive, into a password manager.

Then delete the file:

```bash
rm victoria-id-gpg-private.asc
```

</details>

Any repo whose remote points at `git@github.com:victoria-id/...` automatically
picks up the victoria-id git identity and SSH key, wherever it's cloned — no
particular folder needed.
