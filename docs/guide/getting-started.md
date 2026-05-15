# Getting Started

**Documentation site:** [jackyko1991.github.io/kaizen-spec](https://jackyko1991.github.io/kaizen-spec/)
**GitHub:** [github.com/jackyko1991/kaizen-spec](https://github.com/jackyko1991/kaizen-spec)

This guide walks you through installing kaizen-spec and running your first `/kaizen-spec` session.

---

## Prerequisites

- [Claude Code](https://claude.ai/code) installed (CLI or VS Code extension)
- Git
- Node.js 18+ (only needed if you want to run the VitePress docs site locally)

---

## Install

### Option A - curl one-liner (recommended)

The fastest way to install. Run this in your terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/install.sh | bash
```

This downloads and runs `install.sh`, which copies `kaizen-spec.md` into `~/.claude/commands/` automatically. Claude Code picks it up immediately as `/kaizen-spec`.

If you prefer not to pipe scripts from the internet, you can download the skill file directly:

```bash
curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/.claude/commands/kaizen-spec.md \
  > ~/.claude/commands/kaizen-spec.md
```

To upgrade later, re-run the same command (see [Updating](#updating)).

---

### Option B - dev mode (symlink)

For contributors or power users who want to edit the skill and see changes live - across every project - without reinstalling:

```bash
git clone https://github.com/jackyko1991/kaizen-spec
cd kaizen-spec
make install-dev
# or: bash install.sh --dev
```

This creates a symlink:

```
~/.claude/commands/kaizen-spec.md -> /path/to/kaizen-spec/.claude/commands/kaizen-spec.md
```

**How it works:** When you invoke `/kaizen-spec` in any project, Claude Code reads the symlink target - the live file in your cloned repo. Edit the skill, switch back to your project, invoke `/kaizen-spec` - the change is already there. No reinstall step.

**Typical dev workflow:**
1. You're working on `my-app` and notice a skill bug
2. Open the kaizen-spec repo in a second Claude Code window
3. Edit `.claude/commands/kaizen-spec.md` directly
4. Switch back to `my-app` - the next `/kaizen-spec` call uses the fix
5. When happy, commit and push from the kaizen-spec repo

To switch back to a stable install:

```bash
bash install.sh   # no --dev flag - copies the file, breaking the symlink
```

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

1. Open a project in Claude Code - any project, any language.
2. Type `/kaizen-spec` and describe what you want to build (or leave it blank and answer the questions).
3. Answer the Phase 1 alignment questions. Take your time - this is the most important phase.
4. Confirm the test framework in Phase 2.
5. Watch Phase 3: open `.kaizen/board.html` in a browser to see agent progress live.
6. Phase 4 and 5 complete automatically.

The entire cycle - from spec to working, tested, documented code - typically takes 15–45 minutes depending on feature complexity.

---

## Run the docs site locally

```bash
cd ~/.claude/skills/kaizen-spec
npm install
npm run docs:dev
```

Then open `http://localhost:5173` in your browser.

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

Re-run the install command - it overwrites the existing skill file in place:

```bash
curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/install.sh | bash
```

Or, if you have the repo cloned locally:

```bash
make update
```

Claude Code picks up the new version immediately - no restart needed for the skill file itself.

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
