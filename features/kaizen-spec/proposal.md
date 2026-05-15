# Proposal: kaizen-spec Skill

**Feature ID:** kaizen-spec  
**Status:** Approved - proceed to spec  
**Date:** 2026-05-14  
**Author:** Jacky Ko

---

## Problem

Software development with AI agents today is unstructured. Agents write code immediately without alignment on intent, skip tests, produce no documentation, and have no way to coordinate across parallel workstreams. When a session ends, all context is lost - the next agent starts blind.

The result: code that solves the wrong problem, no tests, no docs, and no continuity.

---

## Proposed Solution

A Claude Code slash command (`/kaizen-spec`) that enforces a structured, kaizen-informed development workflow across five phases:

1. **Spec Alignment** - align on intent before any code is written
2. **Test Strategy** - choose a framework and write failing tests first (red)
3. **Implementation** - subagent-parallelised code writing drives tests green
4. **Acceptance** - tests must pass; user notified for manual verification
5. **Docs in Parallel** - documentation written alongside code

State is persisted in git-tracked files (`.kaizen/` directory), so fresh-context agents can resume at any point without losing progress. A live HTML kanban board reflects real-time agent status with Toyota-style WIP limits and blocker flags.

---

## Goals

- Any developer can run `/kaizen-spec` and produce aligned, tested, documented code
- Agents never write code before a spec is agreed
- All tests start failing (red) and are driven green by implementation - never skipped
- State survives agent context resets via git-tracked files
- The kanban board gives a live, visual picture of agent progress
- Kaizen log records blockers and cycle times for continuous process improvement

---

## Non-Goals

- Not a project management tool for human teams (the board is agent-facing)
- Not a replacement for a full CI/CD pipeline (it integrates with one, not replaces it)
- Not language- or framework-specific (the skill adapts to any stack)

---

## Acceptance Criteria

**The skill is only done when it can be used to develop itself.**

Specifically: running `/kaizen-spec` on the `kaizen-spec` repository must:

1. Produce a `.kaizen/spec.md` that accurately describes a new feature for the skill
2. Generate a `.kaizen/test-strategy.md` with a chosen test framework and failing E2E tests
3. Implement the feature using subagents, driving tests to green
4. Show a live `.kaizen/board.html` with accurate WIP limits and agent status during the run
5. Append structured entries to `.kaizen/kaizen.log` throughout the cycle
6. Produce a VitePress doc page for the new feature in `docs/`

If the skill cannot develop itself, it is not done.

---

## Reference Projects

| Project | What we take from it |
|---|---|
| OpenSpec | Proposal → spec → design → checklist structure; `AskUserQuestion`-driven alignment |
| Superpowers | Enforced TDD, subagent coordination, worktree-per-ticket isolation |
| Ralph | Fresh-context loops, state in files not memory, continuity via git |
| OpenKanban | Live board per worktree, WIP limits, visual agent status |
