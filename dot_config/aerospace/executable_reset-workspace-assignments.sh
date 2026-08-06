#!/bin/sh
set -eu

move_app_windows() {
    app_bundle_id="$1"
    workspace="$2"

    aerospace list-windows --all --format '%{window-id}|%{app-bundle-id}|%{workspace}' |
        while IFS='|' read -r window_id bundle_id current_workspace; do
            [ "$bundle_id" = "$app_bundle_id" ] || continue
            [ "$current_workspace" != "$workspace" ] || continue
            aerospace move-node-to-workspace --window-id "$window_id" "$workspace"
        done
}

move_app_windows 'app.zen-browser.zen' '1'
move_app_windows 'com.apple.Safari' '1'
move_app_windows 'com.google.Chrome' '1'
move_app_windows 'org.mozilla.firefox' '1'

move_app_windows 'com.todesktop.230313mzl4w4u92' '2'
move_app_windows 'com.github.wez.wezterm' '3'
move_app_windows 'com.apple.finder' '4'

move_app_windows 'com.hnc.Discord' '5'
move_app_windows 'com.tinyspeck.slackmacgap' '5'

move_app_windows 'org.gnu.Emacs' 'A'
move_app_windows 'notion.id' 'A'

move_app_windows 'com.apple.Preview' 'P'

move_app_windows 'com.openai.codex' 'R'
move_app_windows 'com.anthropic.claudefordesktop' 'R'
move_app_windows 'com.openai.chat' 'R'

move_app_windows 'net.whatsapp.WhatsApp' 'W'
