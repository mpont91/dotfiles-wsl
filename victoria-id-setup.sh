#!/bin/bash

set -e

export DOTFILES="$HOME/.dotfiles"

echo "Setting up victoria-id..."

ln -sf "$DOTFILES/git/.gitconfig-victoria-id" "$HOME/.gitconfig-victoria-id"
echo "Linked .gitconfig-victoria-id → $HOME/.gitconfig-victoria-id"
echo

if [ ! -f "$HOME/.ssh/victoria-github" ]; then
  echo "No SSH key found at ~/.ssh/victoria-github. Generate one:"
  echo "  ssh-keygen -t ed25519 -f ~/.ssh/victoria-github"
  echo "Then save the public key in your victoria-id github account."
  echo
fi

echo "Victoria-id commits must be GPG-signed. If ~/.gitconfig-victoria-id"
echo "doesn't have a signingkey yet, see the README for how to generate and"
echo "export a GPG key."
echo
echo "Victoria-id ready! Any repo whose remote points at"
echo "git@github.com:victoria-id/... will automatically use this identity —"
echo "no need to clone it into any particular folder."
