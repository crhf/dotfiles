#!/usr/bin/env bash

set -euo pipefail

# Project picker for Zellij sessions.
# Reuses the same search/frecency flow as tmux-sessionizer.sh, but switches or
# attaches to Zellij sessions named after the selected path.

PROJECTS=("$HOME/projects" "$HOME" "$HOME/google-drive")
LAYOUT="${XDG_CONFIG_HOME:-$HOME/.config}/zellij/layouts/worktree-tools.kdl"
export ZELLIJ_SOCKET_DIR="${ZELLIJ_SOCKET_DIR:-/tmp/zellij}"

expand_project_roots() {
  local root
  for root in "${PROJECTS[@]}"; do
    if [ -d "$root" ]; then
      printf '%s\n' "$root"
      find "$root" -mindepth 1 -maxdepth 1 -type d 2>/dev/null
    fi
  done
}

increase() {
  local selected="$1"
  [ "$selected" = "default" ] && return 0
  zoxide add "$selected"
}

search() {
  expand_project_roots |
    while IFS= read -r p; do
      zoxide query -l -s "$p/" 2>/dev/null || true
    done |
    sort -rnk1 |
    uniq |
    awk '{print $2}' |
    fzf --no-sort --prompt "  "
}

session_name_for() {
  local selected="$1"
  local relative name

  case "$selected" in
    "$HOME/projects"/*)
      relative="projects-${selected#"$HOME/projects"/}"
      ;;
    "$HOME/google-drive"/*)
      relative="google-drive-${selected#"$HOME/google-drive"/}"
      ;;
    "$HOME"/*)
      relative="home-${selected#"$HOME"/}"
      relative="${relative#/}"
      ;;
    *)
      relative="$(basename "$selected")"
      ;;
  esac

  name="$(printf '%s' "$relative" | tr '/ .' '---' | tr -cs '[:alnum:]_-' '-')"
  name="${name#-}"
  name="${name%-}"
  name="${name:-default}"

  printf '%s\n' "$name"
}

inside_zellij() {
  [ -n "${ZELLIJ:-}" ] || return 1
  zellij action current-tab-info >/dev/null 2>&1
}

session_exists() {
  local name="$1"
  zellij list-sessions --short 2>/dev/null | grep -Fxq "$name"
}

main() {
  local selected session_name

  if [ "$#" -eq 1 ]; then
    selected="$1"
  else
    selected="$(search)"
  fi

  if [ -z "${selected:-}" ]; then
    exit 0
  fi

  if [ ! -d "$selected" ]; then
    printf 'zellij-sessionizer: not a directory: %s\n' "$selected" >&2
    exit 1
  fi

  session_name="$(session_name_for "$selected")"
  increase "$selected"

  if session_exists "$session_name"; then
    if inside_zellij; then
      zellij action switch-session "$session_name"
    else
      exec zellij attach "$session_name"
    fi
  else
    if inside_zellij; then
      zellij action switch-session --cwd "$selected" --layout "$LAYOUT" "$session_name"
    else
      exec zellij -s "$session_name" -n "$LAYOUT" options --default-cwd "$selected"
    fi
  fi
}

main "$@"
