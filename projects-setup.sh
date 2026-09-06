#!/bin/bash

set -e

# Base directory for projects.
#
# Personal-only (no arguments): personal projects live directly here, flat.
# Full setup (work contexts passed as arguments, see `make projects-full`):
# a "personal" subfolder is added alongside them for organization. Either
# way, the personal git identity is just the default in git/.gitconfig — it
# doesn't need an `includeIf` match, so it works the same regardless of
# whether a project sits directly under here or under personal/.
PROJECTS_DIR="$HOME/projects"

mkdir -p "$PROJECTS_DIR"
echo "Projects folder ready → $PROJECTS_DIR"

if [ "$#" -gt 0 ]; then
  personal_dir="$PROJECTS_DIR/personal"
  personal_created=false
  if [ ! -d "$personal_dir" ]; then
    personal_created=true
  fi

  # Work contexts get their own `~/projects/<context>` subfolder matching an
  # `includeIf` rule in git/.gitconfig, so repos cloned inside automatically
  # get the right git identity/SSH key. Existing folders are left untouched.
  for context in personal "$@"; do
    dir="$PROJECTS_DIR/$context"
    if [ -d "$dir" ]; then
      echo "Exists, skipping → $dir"
    else
      mkdir -p "$dir"
      echo "Created → $dir"
    fi
  done

  if [ "$personal_created" = true ]; then
    echo
    echo "Note: existing repos directly under $PROJECTS_DIR were not moved into personal/ — move them manually if you want."
  fi
fi

echo
echo "Projects structure ready!"
