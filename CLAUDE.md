# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for setting up a Windows machine running WSL (Ubuntu). It targets a machine that holds **multiple identities at once**: personal, and `victoria-id` (work), each with its own git identity and SSH key. There is no build/compile step and no test suite — this is shell scripts and config files that get installed onto a real machine.

## Commands

There's no `install` Makefile target for individual pieces beyond these two (see `Makefile`):

```bash
make install # runs install.sh — apt packages, oh-my-zsh, nvm, pyenv, docker, claude CLI
make config  # runs config.sh  — symlinks all dotfiles (personal + victoria-id) into $HOME, sets zsh as the default shell
```

Intended order on a fresh machine: `install` → `config` (matches the README). There's no separate victoria-id command — `config.sh` always symlinks `.gitconfig-victoria-id` too, since it's inert until a repo's remote actually matches victoria-id (see below). Victoria-id work only additionally needs its own SSH/GPG keys in place, which the README covers.

There is no lint/test tooling in this repo; changes are validated by re-running the relevant script (or reasoning through it) since these scripts are meant to be idempotent (checked with `[ -d ... ]` / `command -v` guards before installing or creating things).

## Architecture: the multi-identity model

The core design point of this repo is that **one physical machine can act as two separate git identities**, selected automatically by each repo's remote URL — not by manually switching config, and not by which directory the repo happens to live in. This is done with git's `includeIf "hasconfig:remote.*.url:..."` (requires Git ≥ 2.36) and a matching SSH `Host` alias:

- `git/.gitconfig` sets the default (personal) identity — this is what applies to any repo that doesn't match the work context below, wherever it lives on disk. It conditionally includes `.gitconfig-victoria-id` when the repo has a remote whose URL matches `git@github.com:victoria-id/**`.
- `.gitconfig-victoria-id` overrides `user.email` and `core.sshCommand` (pointing at a dedicated private key: `victoria-github`). `config.sh` always symlinks it into `$HOME`, even on a personal-only machine — it's harmless there since the `includeIf` above never matches without a victoria-id remote.
- `victoria-id` additionally requires GPG-signed commits (`commit.gpgsign = true`, `user.signingkey` — see README for how to generate/export the key).
- The personal identity has no `core.sshCommand` override, but it does have an explicit `ssh/config` `Host github.com` entry pinning `IdentityFile ~/.ssh/id_ed25519` with `IdentitiesOnly yes`. This pin is required, not cosmetic: if the Windows host ever forwards its own SSH agent into this WSL session (e.g. via a VS Code Remote-WSL or terminal setting outside this repo), that forwarded agent can carry keys from other identities (e.g. a work account's key), and without `IdentitiesOnly yes` restricting `github.com` to the personal key, ssh would offer those forwarded keys first — GitHub accepts whichever key matches any account, silently authenticating as the wrong identity. `ssh/config` also defines an aliased `Host` entry for the work identity (`victoria-github`), plus a URL rewrite in `.gitconfig` (`url "git@github.com-victoria-id:victoria-id/" insteadOf ...`) so victoria-id remotes transparently use the aliased SSH host — this rewrite is why the `hasconfig` pattern above matches the *unaliased* `git@github.com:victoria-id/**` form: that's the literal value git stores in `remote.origin.url`, the alias only applies at connection time.

When editing any of `git/.gitconfig*` or `ssh/config`, treat them as one unit: a change to the victoria-id remote URL pattern or key filename in one must be mirrored in the other.

Because a git `includeIf` and an SSH `Host` block are inert until something actually matches them (a repo with a matching remote, a clone using that host alias), a machine only ever needs the keys for the identity it actually uses — an unused `.gitconfig-*` / `ssh/config` entry just sits dormant. There is deliberately no `~/projects/<context>/` folder convention: which identity applies is a property of the repo's remote, not of where it's cloned.

## Aliases: oh-my-zsh plugins first, `terminal/.aliases` only for what they don't cover

Most one-letter git shortcuts (`g`, `ga`, `gco`, `gst`, `gd`, `gp`, `gl`, `gc`, `gc!`, `glg`, `gru`, `gb`, `gbd`, `gaa`, `gm`) come from the oh-my-zsh `git` plugin, and docker shortcuts (`dco`, `dcb`, `dcup`, ...) from `docker-compose` — both enabled in `terminal/.zshrc`'s `plugins=(...)`. `terminal/.aliases` (sourced *after* oh-my-zsh, so it silently overrides on any name collision) should only add things the plugins don't provide: `dc='docker compose'` (no plain `dc` in any plugin), the workflow functions (`amend`, `force`, `nuke`, `undo` — no plugin equivalent), `stash`/`pop`/`wip` (plugin has these under different names: `gsta`/`gstp`/`gwip`), and `gcmsg='git commit -m'`.

**Do not name anything in `.aliases` `gcm`** — the git plugin already defines `gcm` as "checkout main branch"; a same-named alias here would silently shadow it. Same caution applies to `l`/`la`/`ll`: oh-my-zsh's core (not a plugin, always active) defines these unconditionally, so don't reintroduce them here unless deliberately overriding.

## `config.sh` symlink map

`config.sh` is a flat list of `ln -sf` calls from files in this repo to `$HOME`. When adding a new dotfile to the repo, it is not picked up automatically — add an explicit `link_file` call in `config.sh`. Conversely, a file referenced in `config.sh` that doesn't exist in the repo will fail silently at link time (symlink to a non-existent target), so keep this list in sync with what's actually tracked here.

