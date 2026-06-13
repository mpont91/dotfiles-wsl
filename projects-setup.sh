#!/bin/bash

set -e

# Base directory for all projects. Matches the `includeIf "gitdir:~/projects/..."`
# rules in git/.gitconfig, so each context gets the right git identity.
PROJECTS_DIR="$HOME/projects"

# Contexts to create. Add new ones here as needed.
CONTEXTS=(
  personal
  present-connection
  victoria-id
)

echo "Setting up projects structure in $PROJECTS_DIR..."
echo

for context in "${CONTEXTS[@]}"; do
  dir="$PROJECTS_DIR/$context"
  if [ -d "$dir" ]; then
    echo "Exists, skipping → $dir"
  else
    mkdir -p "$dir"
    echo "Created → $dir"
  fi
done

echo
echo "Projects structure ready!"
