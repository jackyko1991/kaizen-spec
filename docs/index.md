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
      link: https://github.com/jackyko/kaizen-spec

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
    details: Every run appends to a syslog-format kaizen.log — blockers, cycle times, and state transitions. Read it to spot patterns.
  - title: Fresh-context resilient
    details: All state lives in git-tracked files. Agents can restart from zero and resume exactly where they left off.
---
