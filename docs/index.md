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
  - title: Self-hosting
    details: kaizen-spec is developed using kaizen-spec itself. If the skill cannot develop itself, it is not done.
  - title: Toyota Kanban board
    details: A live HTML kanban board tracks agent progress with WIP limits, Andon cord blocker flags, and auto-reload.
  - title: Continuous improvement
    details: Every run appends to a syslog-format kaizen.log - blockers, cycle times, and state transitions. Read it to spot patterns.
  - title: Fresh-context resilient
    details: All state lives in git-tracked files. Agents can restart from zero and resume exactly where they left off.
---

<div class="install-section">

## Install

**Standard** - copies the skill file into Claude Code:

```bash
curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/install.sh | bash
```

Then open any project in Claude Code and type `/kaizen-spec`.

**Dev mode** - symlink so edits in the repo are live everywhere immediately:

```bash
git clone https://github.com/jackyko1991/kaizen-spec
cd kaizen-spec
make install-dev
```

See the [full install guide](/guide/getting-started) for upgrade, uninstall, and troubleshooting.

</div>

<style>
.install-section {
  max-width: 800px;
  margin: 0 auto;
  padding: 2.5rem 1.5rem 3rem;
}

.install-section h2 {
  font-size: 1.6rem;
  font-weight: 700;
  margin-bottom: 1.25rem;
  border-top: 1px solid var(--vp-c-divider);
  padding-top: 2rem;
}

.install-section p {
  margin: 0.6rem 0 0.4rem;
  color: var(--vp-c-text-2);
  font-size: 0.95rem;
}

.install-section div[class*="language-"] {
  margin: 0.4rem 0 1.2rem;
}
</style>
