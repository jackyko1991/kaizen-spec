#!/usr/bin/env bash
# PostToolUse hook — re-renders .kaizen/board.html when tasks.json is written.
# Receives tool call JSON on stdin. Runs render_board.py if tasks.json was touched.
#
# Trigger logic:
#   Agent events   → always re-render (subagents edit tasks.json internally;
#                    the parent hook JSON won't contain "tasks.json" in tool_input)
#   Write/Edit/Bash → re-render only when "tasks.json" appears in tool_input

REPO="/home/jackyko/Projects/kaizen-spec"
TASKS="$REPO/.kaizen/tasks.json"
SCRIPT="$REPO/scripts/render_board.py"

[ -f "$TASKS" ] || exit 0
[ -f "$SCRIPT" ] || exit 0

INPUT="$(cat)"

# Detect tool type from JSON
TOOL_NAME=$(echo "$INPUT" | grep -o '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | grep -o '"[^"]*"$' | tr -d '"')

if [ "$TOOL_NAME" = "Agent" ]; then
    # Agent subagents may have modified tasks.json — always re-render
    python3 "$SCRIPT" >/dev/null 2>&1 || true
elif echo "$INPUT" | grep -q "tasks.json"; then
    python3 "$SCRIPT" >/dev/null 2>&1 || true
fi

exit 0
