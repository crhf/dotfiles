#!/bin/bash
[ -f "$PWD/.claude/tg.off" ] && exit 0
BOT_TOKEN="8413986801:AAE0FbfbY4dxNh1giG9QCh1j69ysuQwInaE"
CHAT_ID="8050785179"
curl -s -o /dev/null "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
  -d chat_id="${CHAT_ID}" \
  -d text="$(basename "$PWD")@$(hostname) is waiting for your input."
