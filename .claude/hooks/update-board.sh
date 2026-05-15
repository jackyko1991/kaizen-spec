#!/usr/bin/env bash
# PostToolUse hook — re-renders .kaizen/board.html after any tool use.
# render_board.py writes a .render-ts sentinel on every run; the board's
# smart-poll detects the changed timestamp and reloads without a flash.
#
# Strategy: always re-render. The script is fast (<100ms) and idempotent.
# We no longer grep stdin for "tasks.json" - that was fragile against tool
# input format changes and missed indirect writes (e.g. via subagents).

REPO="/home/jackyko/Projects/kaizen-spec"
TASKS="$REPO/.kaizen/tasks.json"
SCRIPT="$REPO/scripts/render_board.py"

[ -f "$TASKS" ] || exit 0
[ -f "$SCRIPT" ] || exit 0

python3 "$SCRIPT" >/dev/null 2>&1 || true

exit 0
