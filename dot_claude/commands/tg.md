---
description: Toggle Telegram notifications for this project
allowed-tools: [Bash]
model: haiku
---

Run this exact command and print its output verbatim, nothing else:

```
bash -c 'if [ -f .claude/tg.off ]; then rm .claude/tg.off; echo "Telegram notifications ON"; else mkdir -p .claude; touch .claude/tg.off; echo "Telegram notifications OFF"; fi'
```
