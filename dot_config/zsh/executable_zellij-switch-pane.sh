#!/usr/bin/env bash

set -euo pipefail

inside_zellij() {
  [ -n "${ZELLIJ:-}" ] || return 1
  zellij action current-tab-info >/dev/null 2>&1
}

main() {
  local query="${1:-}"
  local selected pane_id

  if ! inside_zellij; then
    printf 'zellij-switch-pane: run this inside an active Zellij session\n' >&2
    exit 1
  fi

  local panes
  panes="$(
    zellij action list-panes --all --tab --command --state --json | jq -r '
      .[]? |
      {
        id: (.pane_id // .id // .paneId // empty | tostring),
        title: (.title // .pane_title // .name // ""),
        command: (.command // .command_name // .executable // ""),
        tab: (.tab_name // .tab // .tab_title // ""),
        focused: (.is_focused // .focused // false)
      } |
      select(.id != "") |
      [
        ((if .focused then "*" else " " end) + " " +
         (if .tab != "" then "[" + .tab + "] " else "" end) +
         (if .title != "" then .title else "<untitled>" end) +
         (if .command != "" then " {" + .command + "}" else "" end)),
        .id
      ] | @tsv
    '
  )"

  if [ -z "$panes" ]; then
    exit 0
  fi

  if [ -n "$query" ]; then
    selected="$(printf '%s\n' "$panes" | fzf --with-nth=1 --delimiter=$'\t' --select-1 --exit-0 --filter "$query")"
  else
    selected="$(printf '%s\n' "$panes" | fzf --with-nth=1 --delimiter=$'\t')"
  fi

  if [ -z "${selected:-}" ]; then
    exit 0
  fi

  pane_id="$(printf '%s\n' "$selected" | awk -F '\t' '{print $2}')"
  zellij action focus-pane-id "$pane_id"
}

main "$@"
