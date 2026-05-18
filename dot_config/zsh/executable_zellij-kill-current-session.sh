#!/usr/bin/env bash

set -euo pipefail

if [ -z "${ZELLIJ_SESSION_NAME:-}" ]; then
  printf 'zellij-kill-current-session: not inside a Zellij session\n' >&2
  exit 1
fi

exec zellij kill-session "$ZELLIJ_SESSION_NAME"
