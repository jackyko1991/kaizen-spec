#!/usr/bin/env bash
# update-board.sh — PostToolUse hook: touch board.html to trigger auto-reload
# Runs silently after every Agent tool call.

REPO="/home/jackyko/Projects/kaizen-spec"
BOARD="$REPO/.kaizen/board.html"
TASKS="$REPO/.kaizen/tasks.json"

# Exit silently if board doesn't exist yet
[ -f "$BOARD" ] || exit 0

# Update the last-updated timestamp in board.html
NOW="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
sed -i "s|Updated: [0-9T:Z-]*|Updated: $NOW|g" "$BOARD"

exit 0
