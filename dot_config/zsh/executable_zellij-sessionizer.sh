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
  # `list-sessions` also reports serialized EXITED sessions. Those are
  # resurrection candidates, not live sessions, and attaching to one here
  # makes the sessionizer bring back stale layouts.
  zellij list-sessions --no-formatting 2>/dev/null |
    awk -v name="$name" '$1 == name && $0 !~ /\(EXITED/ { found = 1 } END { exit !found }'
}

delete_exited_session() {
  local name="$1"
  local cache_root socket_path pids pid attempt running

  if zellij list-sessions --no-formatting 2>/dev/null |
    awk -v name="$name" '$1 == name && $0 ~ /\(EXITED/ { found = 1 } END { exit !found }'; then
    # Zellij 0.44 can return success here without removing an EXITED session's
    # orphaned server or serialized metadata. Try the CLI first, then clean up
    # only the process and files belonging to this exact session.
    zellij delete-session "$name" >/dev/null 2>&1 || true

    if zellij list-sessions --no-formatting 2>/dev/null |
      awk -v name="$name" '$1 == name && $0 ~ /\(EXITED/ { found = 1 } END { exit !found }'; then
      socket_path="${ZELLIJ_SOCKET_DIR%/}/contract_version_1/$name"

      if [ -S "$socket_path" ] && command -v lsof >/dev/null 2>&1; then
        pids="$(lsof -t -- "$socket_path" 2>/dev/null || true)"
        for pid in $pids; do
          kill "$pid" 2>/dev/null || true
        done

        for attempt in {1..20}; do
          running=false
          for pid in $pids; do
            if kill -0 "$pid" 2>/dev/null; then
              running=true
              break
            fi
          done
          [ "$running" = false ] && break
          sleep 0.1
        done

        for pid in $pids; do
          kill -KILL "$pid" 2>/dev/null || true
        done
      fi

      case "$(uname -s)" in
        Darwin)
          cache_root="${XDG_CACHE_HOME:-$HOME/Library/Caches}/org.Zellij-Contributors.Zellij"
          ;;
        *)
          cache_root="${XDG_CACHE_HOME:-$HOME/.cache}/zellij"
          ;;
      esac

      if [ -d "$cache_root" ]; then
        find "$cache_root" -type d -path "*/session_info/$name" -prune -exec rm -rf -- {} +
      fi

      [ ! -S "$socket_path" ] || rm -f -- "$socket_path"
    fi
  fi
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

  # A serialized session with the same name is automatically resurrected by
  # both `attach` and `switch-session`. Remove it before creating a fresh one.
  delete_exited_session "$session_name"

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
