# kaizen-spec

A Claude Code skill (`/kaizen-spec`) for spec-driven, kaizen-informed, agentic software development.

**The skill is only done when it can be used to develop itself.**

---

## What it does

`/kaizen-spec` enforces a five-phase workflow before any code is written:

| Phase | What happens |
|---|---|
| 1. Spec Alignment | Structured questions lock in intent, scope, and out-of-scope boundaries |
| 2. Test Strategy | You choose a test framework; failing tests are written first (red) |
| 3. Implementation | Subagents work in parallel; a live kanban board tracks their progress |
| 4. Acceptance | All tests must pass before the skill declares done |
| 5. Docs in Parallel | VitePress doc page written alongside the code |

State is persisted in `.kaizen/` (git-tracked) so fresh-context agents can resume at any point.

---

## Install

### 1. Clone the repo

```bash
git clone https://github.com/jackyko/kaizen-spec ~/.claude/skills/kaizen-spec
```

### 2. Link the command

```bash
mkdir -p ~/.claude/commands
ln -s ~/.claude/skills/kaizen-spec/.claude/commands/kaizen-spec.md ~/.claude/commands/kaizen-spec.md
```

### 3. Use it

Open any project in Claude Code and run:

```
/kaizen-spec
```

---

## Documentation

Full docs live in `docs/`. Run locally:

```bash
npm install
npx vitepress dev docs
```

Or visit the GitHub Pages site once deployed.

## Philosophy

- **Toyota Kanban**: WIP limits, pull-not-push, visual management, Andon cord for blockers
- **Kaizen**: Continuous improvement — every run logs cycle times and blockers to `kaizen.log`
- **Ralph-style continuity**: State in files, not agent memory — agents restart cleanly
- **OpenSpec alignment**: No code before the spec is committed and agreed

## License

MIT
