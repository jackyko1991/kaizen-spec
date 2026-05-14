#!/usr/bin/env bash
set -e

REPO="/home/jackyko/Projects/kaizen-spec"
BOARD="$REPO/.kaizen/board.html"

[ -f "$BOARD" ] || exit 0

NOW="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
sed -i "s|Updated: [0-9T:Z-]*|Updated: $NOW|g" "$BOARD"

exit 0
