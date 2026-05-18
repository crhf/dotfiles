#!/usr/bin/env bash

set -euo pipefail

inside_zellij() {
  [ -n "${ZELLIJ:-}" ] || return 1
  zellij action current-tab-info >/dev/null 2>&1
}

main() {
  local query="${1:-}"
  local selected

  if ! inside_zellij; then
    printf 'zellij-switch-tab: run this inside an active Zellij session\n' >&2
    exit 1
  fi

  if [ -n "$query" ]; then
    selected="$(zellij action query-tab-names | sed '/^$/d' | fzf --select-1 --exit-0 --filter "$query")"
  else
    selected="$(zellij action query-tab-names | sed '/^$/d' | fzf)"
  fi

  if [ -z "${selected:-}" ]; then
    exit 0
  fi

  zellij action go-to-tab-name "$selected"
}

main "$@"
