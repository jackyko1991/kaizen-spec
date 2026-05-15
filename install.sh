#!/usr/bin/env bash
# kaizen-spec installer - requires bash + curl (or wget). Windows: use WSL.
#
# Normal install (copies skill file):
#   curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/install.sh | bash
#
# Dev install (symlink - edits in the repo are live immediately):
#   git clone https://github.com/jackyko1991/kaizen-spec
#   bash kaizen-spec/install.sh --dev
set -e

DEV_MODE=0
for arg in "$@"; do
  [ "$arg" = "--dev" ] && DEV_MODE=1
done

SKILL_URL="https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/.claude/commands/kaizen-spec.md"

if [ -n "$INSTALL_DIR" ]; then
  TARGET_DIR="$INSTALL_DIR/.claude/commands"
else
  TARGET_DIR="$HOME/.claude/commands"
fi

mkdir -p "$TARGET_DIR"

DEST="$TARGET_DIR/kaizen-spec.md"

# Resolve the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_SKILL="$SCRIPT_DIR/.claude/commands/kaizen-spec.md"

if [ "$DEV_MODE" = "1" ]; then
  # Dev mode: symlink so edits in the repo are immediately live everywhere
  if [ ! -f "$LOCAL_SKILL" ]; then
    echo "Error: --dev requires running install.sh from inside the cloned repo." >&2
    echo "  Clone first: git clone https://github.com/jackyko1991/kaizen-spec" >&2
    exit 1
  fi
  ln -sf "$LOCAL_SKILL" "$DEST"
  echo "✓ kaizen-spec (dev symlink) -> $LOCAL_SKILL"
  echo "  Edits to $(dirname "$LOCAL_SKILL")/kaizen-spec.md are live immediately."
  echo "  To switch back to a stable install: bash install.sh  (no --dev flag)"
else
  # Normal install: copy the file
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
fi

# Append kaizen-spec reference to the project CLAUDE.md if one exists here
CLAUDE_MD="$(pwd)/CLAUDE.md"
MARKER="kaizen-spec"
if [ -f "$CLAUDE_MD" ] && ! grep -q "$MARKER" "$CLAUDE_MD"; then
  cat >> "$CLAUDE_MD" <<'BLOCK'

## kaizen-spec

This project uses the kaizen-spec skill for spec-driven, test-first development.

- Invoke with `/kaizen-spec` in Claude Code.
- Skill installed at: `~/.claude/commands/kaizen-spec.md`
- Docs: https://jackyko1991.github.io/kaizen-spec/
BLOCK
  echo "✓ Reference added to $CLAUDE_MD"
fi
