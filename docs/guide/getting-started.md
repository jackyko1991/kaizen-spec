# Getting Started

This guide walks you through installing kaizen-spec and running your first `/kaizen-spec` session.

---

## Prerequisites

- [Claude Code](https://claude.ai/code) installed (CLI or VS Code extension)
- Git
- Node.js 18+ (only needed if you want to run the VitePress docs site locally)

---

## Install

### Option A — Clone and link (recommended)

Clone kaizen-spec into a stable location, then symlink the command file so Claude Code picks it up.

```bash
# 1. Clone to a permanent location
git clone https://github.com/jackyko/kaizen-spec ~/.claude/skills/kaizen-spec

# 2. Create the commands directory if it doesn't exist
mkdir -p ~/.claude/commands

# 3. Symlink the skill into Claude Code's commands folder
ln -s ~/.claude/skills/kaizen-spec/.claude/commands/kaizen-spec.md \
      ~/.claude/commands/kaizen-spec.md
```

That's it. Claude Code automatically discovers any `.md` file in `~/.claude/commands/` as a slash command.

### Option B — Copy the command file directly

If you prefer not to symlink:

```bash
mkdir -p ~/.claude/commands
curl -sL https://raw.githubusercontent.com/jackyko/kaizen-spec/main/.claude/commands/kaizen-spec.md \
  > ~/.claude/commands/kaizen-spec.md
```

Note: with this option you will not receive updates automatically. Re-run the command to upgrade.

---

## Verify the install

Open any project in Claude Code and type:

```
/kaizen-spec
```

If installed correctly, the skill will start Phase 1 and ask you: "What is the core problem this feature solves, or what does it add?"

If the command is not found, check that `~/.claude/commands/kaizen-spec.md` exists:

```bash
ls -la ~/.claude/commands/kaizen-spec.md
```

---

## Your first run

1. Open a project in Claude Code — any project, any language.
2. Type `/kaizen-spec` and describe what you want to build (or leave it blank and answer the questions).
3. Answer the Phase 1 alignment questions. Take your time — this is the most important phase.
4. Confirm the test framework in Phase 2.
5. Watch Phase 3: open `.kaizen/board.html` in a browser to see agent progress live.
6. Phase 4 and 5 complete automatically.

The entire cycle — from spec to working, tested, documented code — typically takes 15–45 minutes depending on feature complexity.

---

## Run the docs site locally

```bash
cd ~/.claude/skills/kaizen-spec
npm install
npm run docs:dev
```

Then open [http://localhost:5173](http://localhost:5173).

---

## Self-hosting test (advanced)

The ultimate test of the install: use kaizen-spec to develop kaizen-spec itself.

```bash
cd ~/.claude/skills/kaizen-spec
# open in Claude Code, then run:
/kaizen-spec "add a kaizen-log tail command that shows the last N entries"
```

If all five phases complete and the board shows all cards in Done, the install is working correctly. See [checklist.md](https://github.com/jackyko/kaizen-spec/blob/main/features/kaizen-spec/checklist.md) Phase 6 for the full self-hosting acceptance criteria.

---

## Updating

If you installed with Option A (symlink):

```bash
cd ~/.claude/skills/kaizen-spec
git pull
```

The symlink means Claude Code immediately picks up the updated skill — no re-linking needed.

---

## Uninstall

```bash
rm ~/.claude/commands/kaizen-spec.md
# optionally:
rm -rf ~/.claude/skills/kaizen-spec
```

---

## Troubleshooting

**`/kaizen-spec` not found in Claude Code**

Check the commands directory:
```bash
ls ~/.claude/commands/
```
The file `kaizen-spec.md` must be present. If you used a symlink, verify it resolves:
```bash
readlink -f ~/.claude/commands/kaizen-spec.md
```

**The skill starts but does not use `AskUserQuestion`**

This means Claude Code is running in a context that does not support interactive tool use (e.g. a non-interactive pipe). Run it from the Claude Code interactive session, not from a script.

**`.kaizen/board.html` does not auto-reload**

The board polls `location.reload()` every 5 seconds. Make sure you are opening the file directly in a browser (file:// or local HTTP server), not in a preview pane that blocks JavaScript.

**A test passes before implementation (Phase 2 warning)**

The skill stops here intentionally. It means either:
- The test is testing the wrong thing (vacuous test)
- The feature already partially exists

Read the test output, fix the test so it actually fails, then re-run Phase 2.
