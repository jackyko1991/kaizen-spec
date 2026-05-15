---
layout: home

hero:
  name: kaizen-spec
  text: Spec-driven agentic development
  tagline: No code before the spec is agreed. No "done" before the tests pass. No shortcuts.
  actions:
    - theme: brand
      text: Get Started
      link: /guide/getting-started
    - theme: alt
      text: View on GitHub
      link: https://github.com/jackyko1991/kaizen-spec

features:
  - title: Spec first, always
    details: Every feature starts with structured alignment questions. Agents never write code before the spec is committed to git.
  - title: TDD enforced
    details: Failing tests are written before implementation begins. The skill verifies they are red. Acceptance is blocked until they are all green.
  - title: Lean Development Kanban
    details: Grounded in Toyota Production System principles - Muda elimination, Jidoka, one-piece flow. Every practice maps directly to a proven TPS concept.
  - title: Toyota Kanban board
    details: A live HTML kanban board tracks agent progress with WIP limits, Andon cord blocker flags, and auto-reload.
  - title: Continuous improvement
    details: Every run appends to a syslog-format kaizen.log - blockers, cycle times, and state transitions. Read it to spot patterns.
  - title: Fresh-context resilient
    details: All state lives in git-tracked files. Agents can restart from zero and resume exactly where they left off.
---

<div class="install-section">

## Install

<div class="install-cols">
<div class="install-col">

**Standard** - copies the skill into Claude Code:

```bash
curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/install.sh | bash
```

Open any project in Claude Code and type `/kaizen-spec`.

</div>
<div class="install-col">

**Dev mode** - symlink so repo edits are live everywhere:

```bash
git clone https://github.com/jackyko1991/kaizen-spec
cd kaizen-spec
make install-dev
```

See the [full install guide](/guide/getting-started) for upgrade, uninstall, and troubleshooting.

</div>
</div>

</div>

<style>
.install-section {
  max-width: 1152px;
  margin: 0 auto;
  padding: 2.5rem 1.5rem 3rem;
  border-top: 1px solid var(--vp-c-divider);
}

.install-section h2 {
  font-size: 1.6rem;
  font-weight: 700;
  margin-bottom: 1.5rem;
}

.install-cols {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
}

@media (max-width: 768px) {
  .install-cols { grid-template-columns: 1fr; }
}

.install-col p {
  margin: 0.4rem 0;
  color: var(--vp-c-text-2);
  font-size: 0.95rem;
}

.install-col div[class*="language-"] {
  margin: 0.4rem 0 0.8rem;
}
</style>
