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

# ─── Git ────────────────────────────────────────────────────────────────────
echo "Setting up git..."
link_file "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES/git/.gitconfig-present-connection" "$HOME/.gitconfig-present-connection"
link_file "$DOTFILES/git/.gitconfig-victoria-id" "$HOME/.gitconfig-victoria-id"
echo

# ─── SSH ────────────────────────────────────────────────────────────────────
echo "Setting up ssh..."
link_file "$DOTFILES/ssh/config" "$HOME/.ssh/config"
if [ -f "$DOTFILES/ssh/config.local" ]; then
  link_file "$DOTFILES/ssh/config.local" "$HOME/.ssh/config.local"
fi
echo

# ─── Terminal ───────────────────────────────────────────────────────────────
echo "Setting up terminal..."
link_file "$DOTFILES/terminal/.aliases" "$HOME/.aliases"
link_file "$DOTFILES/terminal/.zshrc" "$HOME/.zshrc"
echo

echo "All configs created successfully!"
