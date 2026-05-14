#!/usr/bin/env bash
# PostToolUse hook — re-renders .kaizen/board.html when tasks.json is written.
# Receives tool call JSON on stdin. Runs render_board.py if tasks.json was touched.

REPO="/home/jackyko/Projects/kaizen-spec"
TASKS="$REPO/.kaizen/tasks.json"
SCRIPT="$REPO/scripts/render_board.py"

[ -f "$TASKS" ] || exit 0
[ -f "$SCRIPT" ] || exit 0

# Read stdin (tool call JSON) and check if tasks.json was the target
INPUT="$(cat)"
if echo "$INPUT" | grep -q "tasks.json"; then
    python3 "$SCRIPT" >/dev/null 2>&1 || true
fi

exit 0
