#!/usr/bin/env bash
# kaizen-spec installer — requires bash + curl (or wget). Windows: use WSL.
set -e

SKILL_URL="https://raw.githubusercontent.com/jackyko1991/kaizen-spec/main/.claude/commands/kaizen-spec.md"

if [ -n "$INSTALL_DIR" ]; then
  TARGET_DIR="$INSTALL_DIR/.claude/commands"
else
  TARGET_DIR="$HOME/.claude/commands"
fi

mkdir -p "$TARGET_DIR"

DEST="$TARGET_DIR/kaizen-spec.md"

# Prefer local copy so cloned-repo installs never need network
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_SKILL="$SCRIPT_DIR/.claude/commands/kaizen-spec.md"

if [ -f "$LOCAL_SKILL" ]; then
  cp "$LOCAL_SKILL" "$DEST"
elif command -v curl >/dev/null 2>&1; then
  curl -fsSL "$SKILL_URL" -o "$DEST"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$DEST" "$SKILL_URL"
else
  echo "Error: neither curl nor wget is available. Please install one and retry." >&2
  exit 1
fi

echo "✓ kaizen-spec installed to $DEST"
echo "  Restart Claude Code, then type /kaizen-spec to use it."
