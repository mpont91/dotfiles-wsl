#!/bin/bash

set -e

export DOTFILES="$HOME/.dotfiles"

echo "Initializing dotfiles configuration..."
echo

# Helper function
link_file() {
  local src=$1
  local dest=$2
  ln -sf "$src" "$dest"
  echo "Linked $(basename "$src") → $dest"
}

# ─── Editors ────────────────────────────────────────────────────────────────
echo "Setting up editors..."
link_file "$DOTFILES/editors/vim/.vimrc" "$HOME/.vimrc"
echo

# ─── Git ────────────────────────────────────────────────────────────────────
echo "Setting up git..."
link_file "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES/git/.gitconfig-github" "$HOME/.gitconfig-github"
link_file "$DOTFILES/git/.gitconfig-bitbucket" "$HOME/.gitconfig-bitbucket"
echo

# ─── SSH ────────────────────────────────────────────────────────────────────
echo "Setting up ssh..."
link_file "$DOTFILES/ssh/ssh-config" "$HOME/.ssh/config"
echo

# ─── Terminal ───────────────────────────────────────────────────────────────
echo "Setting up terminal..."
link_file "$DOTFILES/terminal/.aliases" "$HOME/.aliases"
link_file "$DOTFILES/terminal/.zshrc" "$HOME/.zshrc"
echo

echo "All symlinks created successfully!"
