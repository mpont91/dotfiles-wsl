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
make projects  # runs projects-setup.sh — creates ~/projects/<context> folders
```

Intended order on a fresh machine: `install` → `config` → `zsh` → `projects` (matches the README).

There is no lint/test tooling in this repo; changes are validated by re-running the relevant script (or reasoning through it) since these scripts are meant to be idempotent (checked with `[ -d ... ]` / `command -v` guards before installing or creating things).

## Architecture: the multi-identity model

The core design point of this repo is that **one physical machine can act as three separate git identities**, selected automatically by which directory a repo lives in — not by manually switching config. This is done with git's `includeIf "gitdir:"` and matching SSH `Host` aliases:

- `git/.gitconfig` sets the default (personal) identity and conditionally includes `.gitconfig-present-connection` or `.gitconfig-victoria-id` when the repo path is under `~/projects/present-connection/` or `~/projects/victoria-id/` respectively.
- Each per-context `.gitconfig-*` file overrides `user.email` and `core.sshCommand` (pointing at a dedicated private key: `pc-bitbucket`, `victoria-github`).
- `victoria-id` additionally requires GPG-signed commits (`commit.gpgsign = true`, `user.signingkey` — see README for how to generate/export the key).
- `ssh/config` defines the matching `Host` entries and `IdentityFile`s (`personal-github`, `victoria-github`, `pc-bitbucket`) so `git@github.com`-style remotes resolve to the right key per context. There's also a URL rewrite in `.gitconfig` (`url "git@github.com-victoria-id:victoria-id/" insteadOf ...`) so victoria-id remotes transparently use the aliased SSH host.
- `projects-setup.sh` creates the three `~/projects/<context>/` folders these rules depend on. **The folder name is load-bearing** — it's what the `includeIf "gitdir:"` rules match on, so if you rename or restructure these folders, update `git/.gitconfig` and `projects-setup.sh` together.

When editing any of `git/.gitconfig*`, `ssh/config`, or `projects-setup.sh`, treat them as one unit: a change to a context name or key filename in one must be mirrored in the others.

## `config.sh` symlink map

`config.sh` is a flat list of `ln -sf` calls from files in this repo to `$HOME`. When adding a new dotfile to the repo, it is not picked up automatically — add an explicit `link_file` call in `config.sh`. Conversely, a file referenced in `config.sh` that doesn't exist in the repo will fail silently at link time (symlink to a non-existent target), so keep this list in sync with what's actually tracked here.

## Ongoing direction: a "personal-only" variant

There's an in-progress idea (not yet implemented) to support a **simpler personal-only setup** for a single-identity machine: one SSH key only, and no need for the three `~/projects/<context>` subfolders — just a flat project directory. If asked to work on this, keep in mind it's a *reduced* variant of the current multi-identity design above, not an unrelated one — most of the reduction happens in `projects-setup.sh` and `git/.gitconfig` (dropping the `includeIf` blocks and per-context files).
