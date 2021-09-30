#!/bin/bash
# finds out if in the repository is the "master" or "main" branch

# Usage: master_or_main_branch [<path to repository>]

master_or_main_branch() {
  if [ $# -eq 1 ]; then
    cd $1
  fi
  echo "$(git branch -a | grep -E "^(\*? *)(main|master)$" | sed 's/\*//' | xargs)"
}

