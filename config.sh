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
echo

# ─── SSH ────────────────────────────────────────────────────────────────────
echo "Setting up ssh..."
link_file "$DOTFILES/ssh/config" "$HOME/.ssh/config"
if [ ! -f "$DOTFILES/ssh/config.local" ]; then
  cp "$DOTFILES/ssh/config.local.example" "$DOTFILES/ssh/config.local"
  echo "Created ssh/config.local from example — edit it with this machine's own hosts"
fi
link_file "$DOTFILES/ssh/config.local" "$HOME/.ssh/config.local"
echo

# ─── Terminal ───────────────────────────────────────────────────────────────
echo "Setting up terminal..."
link_file "$DOTFILES/terminal/.aliases" "$HOME/.aliases"
link_file "$DOTFILES/terminal/.zshrc" "$HOME/.zshrc"
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)"
  echo "Default shell set to zsh (takes effect on next login)"
fi
echo

echo "All configs created successfully!"
