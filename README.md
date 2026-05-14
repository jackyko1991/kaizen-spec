# kaizen-spec

An Agentic Coding skill (`/kaizen-spec`) for spec-driven, kaizen-informed, agentic software development.

**The skill is only done when it can be used to develop itself.**

📖 **[Documentation](https://jackyko1991.github.io/kaizen-spec/)** · 🐙 **[GitHub](https://github.com/jackyko1991/kaizen-spec)** · 📄 **[MIT License](LICENSE)**

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

kaizen-spec is grounded in the Toyota Production System (TPS) as translated to software by Mary and Tom Poppendieck in *Lean Software Development*.

- **Muda (無駄) → Unshipped code is waste.** In TPS, inventory piling up on the factory floor is the canonical waste. In software, it is code written but not deployed — accruing maintenance cost and obsolescence risk.
- **Just-in-Time (JIT) → CI/CD.** Features are developed only when pulled by demand, and immediately enter the pipeline for validation. Push-based big-batch releases are the software equivalent of overproduction.
- **Jidoka (自働化) → TDD.** When code breaks an existing feature, the test suite pulls the Andon cord and stops the line — exactly as a Toyota worker stops the assembly line on detecting a defect. Defects never reach production.
- **Poka-Yoke (防呆) → Static typing, linting, schema validation.** Errors are made impossible at the moment of writing, not caught at runtime.
- **Kaizen → Spec Kaizen.** When agent-generated tests fail, the failure feeds back into the spec. The spec itself improves — not just the code.
- **One-piece flow → Atomic Specs.** One agent, one task, one responsibility. Small atomic specs maximise agent accuracy and shorten Cycle Time.
- **Decide late → Lean Spec.** Avoid big-upfront design. Define only what the next task needs (Just-in-Time Spec); keep the rest as high-level interface definitions until tests and data demand specifics.
- **State in files, not memory → Fresh-context continuity.** Agents restart; files don't. Everything important is written to `.kaizen/` so any fresh agent can resume without asking the user to re-explain context.

## License

MIT
