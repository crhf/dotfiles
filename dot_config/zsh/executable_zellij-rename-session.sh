#!/bin/zsh

set -euo pipefail

if [[ -z "${ZELLIJ_SESSION_NAME:-}" ]]; then
  print -u2 "Not inside a Zellij session."
  exit 1
fi

current_name="$ZELLIJ_SESSION_NAME"
print -n "Rename session [$current_name]: "
IFS= read -r new_name

if [[ -z "$new_name" || "$new_name" == "$current_name" ]]; then
  exit 0
fi

zellij action rename-session "$new_name"
