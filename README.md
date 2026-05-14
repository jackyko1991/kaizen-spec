# kaizen-spec

An Agentic Coding skill (`/kaizen-spec`) for spec-driven, kaizen-informed, agentic software development.

**The skill is only done when it can be used to develop itself.**

📖 **[Documentation](https://jackyko1991.github.io/kaizen-spec/)** 
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

Open any project in your coding agent and run:

```
/kaizen-spec
```

---

## Monitor progress (kanban board)

Each `/kaizen-spec` cycle generates a live kanban board at `.kaizen/board.html`. On a server (no local browser), serve it with:

```bash
make board
# → http://localhost:8080/board.html
# Set PORT=9090 to use a different port
```

Or directly with Python:

```bash
cd .kaizen && python3 -m http.server 8080
```

The board auto-reloads every 5 seconds as agents move cards.

---

## Documentation

Full docs live in `docs/`. Run locally:

```bash
npm install
npx vitepress dev docs
```

Or visit the GitHub Pages site once deployed.

## Philosophy

kaizen-spec is grounded in the Toyota Production System (TPS) as translated to software by Mary and Tom Poppendieck in *Lean Software Development*. Each Toyota concept maps directly to a software practice enforced by this skill:

| Toyota / TPS | JP | Software equivalent | What breaks without it |
|---|---|---|---|
| Muda — waste elimination | 無駄 | Unshipped code is inventory waste | Code accrues maintenance cost and obsolescence risk before it reaches users |
| Just-in-Time (JIT) | ジャスト・イン・タイム | CI/CD — pull-based delivery | Big-batch releases accumulate risk; defects compound before detection |
| Jidoka — autonomation | 自働化 | TDD — tests pull the Andon cord | Defects flow downstream into production; no sensor to stop the line |
| Poka-Yoke — mistake-proofing | 防呆 | Static typing, linting, schema validation | Errors are caught at runtime or by users instead of at the point of writing |
| Kaizen — continuous improvement | 改善 | Spec Kaizen — test failures feed back into the spec | Specs drift from reality; agents repeatedly solve the wrong problem |
| One-piece flow | 一個流 | Atomic Specs — one agent, one task, one responsibility | Large context windows reduce agent accuracy; long tasks can't be parallelised |
| Decide late | — | Lean Spec — Just-in-Time design | Big-upfront specs become stale before implementation; over-engineering is baked in |
| Standard Work | 標準作業 | State in `.kaizen/` files, not agent memory | Fresh-context agents cannot resume; users must re-explain context from scratch |

## License

**[MIT License](LICENSE)**
