# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for setting up a Windows machine running WSL (Ubuntu). It targets a machine that holds **multiple identities at once**: personal, `present-connection` (work), and `victoria-id` (work), each with its own git identity and SSH key. There is no build/compile step and no test suite — this is shell scripts and config files that get installed onto a real machine.

## Commands

There's no `install` Makefile target for individual pieces beyond these four (see `Makefile`):

```bash
make install   # runs install.sh  — apt packages, oh-my-zsh, nvm, pyenv, docker, claude CLI
make config    # runs config.sh   — symlinks dotfiles into $HOME
make zsh       # chsh -s $(which zsh)
make projects       # runs projects-setup.sh — creates ~/projects/personal only
make projects-full  # runs projects-setup.sh present-connection victoria-id — adds the work contexts on top
```

Intended order on a fresh machine: `install` → `config` → `zsh` → `projects` (matches the README).

There is no lint/test tooling in this repo; changes are validated by re-running the relevant script (or reasoning through it) since these scripts are meant to be idempotent (checked with `[ -d ... ]` / `command -v` guards before installing or creating things).

## Architecture: the multi-identity model

The core design point of this repo is that **one physical machine can act as three separate git identities**, selected automatically by which directory a repo lives in — not by manually switching config. This is done with git's `includeIf "gitdir:"` and matching SSH `Host` aliases:

- `git/.gitconfig` sets the default (personal) identity — this is what applies to any repo that doesn't match a work context below, including personal projects living directly in `~/projects/`. It conditionally includes `.gitconfig-present-connection` or `.gitconfig-victoria-id` when the repo path is under `~/projects/present-connection/` or `~/projects/victoria-id/` respectively.
- Each per-context `.gitconfig-*` file overrides `user.email` and `core.sshCommand` (pointing at a dedicated private key: `pc-bitbucket`, `victoria-github`).
- `victoria-id` additionally requires GPG-signed commits (`commit.gpgsign = true`, `user.signingkey` — see README for how to generate/export the key).
- The personal identity has no `core.sshCommand` override, but it does have an explicit `ssh/config` `Host github.com` entry pinning `IdentityFile ~/.ssh/id_ed25519` with `IdentitiesOnly yes` — the same default key name/path on both a personal-only and a shared work+personal machine. This pin is required, not cosmetic: with SSH agent forwarding enabled (`terminal/ssh-agent-config.zsh`), a forwarded agent can carry keys from other identities (e.g. a work account's key), and without `IdentitiesOnly yes` restricting `github.com` to the personal key, ssh would offer those forwarded keys first — GitHub accepts whichever key matches any account, silently authenticating as the wrong identity. `ssh/config` also defines aliased `Host` entries for the two work identities (`victoria-github`, `pc-bitbucket`), plus a URL rewrite in `.gitconfig` (`url "git@github.com-victoria-id:victoria-id/" insteadOf ...`) so victoria-id remotes transparently use the aliased SSH host.
- `projects-setup.sh` creates the `~/projects/<context>/` folders the work `includeIf` rules depend on. **The folder name is load-bearing** — it's what the `includeIf "gitdir:"` rules match on, so if you rename or restructure these folders, update `git/.gitconfig` and `projects-setup.sh` together.

When editing any of `git/.gitconfig*`, `ssh/config`, or `projects-setup.sh`, treat them as one unit: a change to a context name or key filename in one must be mirrored in the others.

Because a git `includeIf` and an SSH `Host` block are inert until something actually matches them (a repo under that gitdir, a clone using that host alias), a machine only ever needs the folders/keys for the contexts it actually uses — the unused `.gitconfig-*` / `ssh/config` entries just sit dormant. This is what makes the personal/full split below possible without maintaining two separate configs.

### Personal-only vs. full setup

`projects-setup.sh` always ensures `~/projects` exists. What subfolders get created depends on whether any work context is passed as an argument:

- `make projects` → just `~/projects`, nothing else. Personal projects live flat, directly inside it. Zero extra SSH/git config needed — personal already is the default identity and default SSH key.
- `make projects-full` → also creates a `personal/` subfolder (for organization, alongside the work ones — it needs no `includeIf`, since personal is the default regardless of path) plus `present-connection` and `victoria-id` (requires the extra SSH keys and, for victoria-id, a GPG key — see README).

Both are idempotent and additive — running `make projects-full` later on a machine that already has `make projects` only adds the missing subfolders, and does **not** move any pre-existing flat repos into `personal/`.

## Aliases: oh-my-zsh plugins first, `terminal/.aliases` only for what they don't cover

Most one-letter git shortcuts (`g`, `ga`, `gco`, `gst`, `gd`, `gp`, `gl`, `gc`, `gc!`, `glg`, `gru`, `gb`, `gbd`, `gaa`, `gm`) come from the oh-my-zsh `git` plugin, and docker shortcuts (`dco`, `dcb`, `dcup`, ...) from `docker-compose` — both enabled in `terminal/.zshrc`'s `plugins=(...)`. `terminal/.aliases` (sourced *after* oh-my-zsh, so it silently overrides on any name collision) should only add things the plugins don't provide: `dc='docker compose'` (no plain `dc` in any plugin), the workflow functions (`amend`, `force`, `nuke`, `undo` — no plugin equivalent), `stash`/`pop`/`wip` (plugin has these under different names: `gsta`/`gstp`/`gwip`), and `gcmsg='git commit -m'`.

**Do not name anything in `.aliases` `gcm`** — the git plugin already defines `gcm` as "checkout main branch"; a same-named alias here would silently shadow it. Same caution applies to `l`/`la`/`ll`: oh-my-zsh's core (not a plugin, always active) defines these unconditionally, so don't reintroduce them here unless deliberately overriding.

## `config.sh` symlink map

`config.sh` is a flat list of `ln -sf` calls from files in this repo to `$HOME`. When adding a new dotfile to the repo, it is not picked up automatically — add an explicit `link_file` call in `config.sh`. Conversely, a file referenced in `config.sh` that doesn't exist in the repo will fail silently at link time (symlink to a non-existent target), so keep this list in sync with what's actually tracked here.

