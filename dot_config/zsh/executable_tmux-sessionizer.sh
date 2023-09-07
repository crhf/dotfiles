#!/usr/bin/env bash
# I organize my projects in ~/Developer/org/name, and I'd like to create sessions for each of them.
# This script uses a combination of find, zoxide (so they are sort by frecency) and fzf to list and filter project folders.
# Then, it either switch to an existing tmux session for that project, or create a new one and switch to it.
#
# Stole and modified from: https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-sessionizer

PROJECTS="$HOME/projects $(echo ~/projects/*) $HOME"

# increase frecency
increase() {
	selected="$1"
	if [ "$selected" = default ]; then
		return 0
	fi
	# zoxide add "$PROJECTS/$selected"
	zoxide add "$selected"
}

search() {
	find $PROJECTS -maxdepth 1 -type d |
		while read -r p; do
			zoxide query -l -s "$p/"
		done |
		sort -rnk1 |       # sort by score
		uniq |             # dedup
		awk '{print $2}' | # do not actually print the score
		fzf --no-sort --prompt "  "
}

if [ "$#" -eq 1 ]; then
	selected="$1"
else
	selected=$(search)
fi

if test -z $selected; then
	exit 0
fi

selected_name="$(echo "$selected" | tr . _)"
tmux_running="$(pgrep tmux)"

if test -z "$TMUX" && test -z "$tmux_running"; then
	# tmux new-session -s "$selected_name" -c "$PROJECTS/$selected"
	tmux new-session -s "$selected_name" -c "$selected"
	increase "$selected"
	exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
	# tmux new-session -ds "$selected_name" -c "$PROJECTS/$selected"
	tmux new-session -ds "$selected_name" -c "$selected"
fi

if test -z "$TMUX"; then
	tmux attach -t "$selected_name"
else
	tmux switch-client -t "$selected_name"
fi
increase "$selected"
