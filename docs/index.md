---
layout: home

hero:
  name: kaizen-spec
  text: Lean-first agentic development skills
  tagline: Toyota Production System principles applied to AI agent workflows. Decide late. Build quality in. No shortcuts.
  actions:
    - theme: brand
      text: Get Started
      link: /guide/getting-started
    - theme: alt
      text: View on GitHub
      link: https://github.com/jackyko1991/kaizen-spec
---

<div class="ks-home">

<div class="ks-top">
<div class="ks-cards">

<div class="ks-card">
<div class="ks-card-icon">📋</div>
<div class="ks-card-body">
<h3>Spec before code</h3>
<p>Every feature starts with structured alignment questions. Agents never write code until the spec is committed to git. <strong>Decide Late</strong> - the last responsible moment, not the first excited moment.</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">🔴</div>
<div class="ks-card-body">
<h3>Tests red before green</h3>
<p>Failing tests are written before implementation. The skill confirms they are red. Acceptance is blocked until all pass. <strong>Jidoka</strong> - stop the line the moment a defect is found.</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">🔢</div>
<div class="ks-card-body">
<h3>WIP limits + one-piece flow</h3>
<p>The kanban board enforces work-in-progress limits. Tasks move one at a time from backlog to done - no batching, no multitasking. <strong>Muda elimination</strong> through flow, not speed.</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">🏭</div>
<div class="ks-card-body">
<h3>Lean Development / TPS</h3>
<p>Built on the Toyota Production System: Muda (waste elimination), Jidoka (built-in quality), Kaizen (continuous improvement), Heijunka (level loading), and Genchi Genbutsu (go see). Every practice maps to a proven TPS concept.</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">📊</div>
<div class="ks-card-body">
<h3>Kanban workflow</h3>
<p>A live HTML kanban board tracks agent progress with WIP limits, Andon cord blocker flags, and auto-reload. Drag tasks across columns and watch the board update in real time.</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">📁</div>
<div class="ks-card-body">
<h3>Standard Work + fresh-context resilient</h3>
<p>All state lives in git-tracked files. Agents restart from zero and resume exactly where they left off. <strong>Standard Work (標準作業)</strong> - every action is documented, repeatable, and auditable.</p>
</div>
</div>

</div><!-- .ks-cards -->

<aside class="ks-install">
<h3>Install</h3>

```bash
curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/install.sh | bash
```

Open any project in Claude Code and type `/kaizen-spec`.

<a href="/guide/getting-started" class="ks-install-link">Full install guide →</a>
</aside>
</div><!-- .ks-top -->

<div class="ks-kanban">
<h2>How it works - live board</h2>

<div class="kb-board">

<div class="kb-col">
<div class="kb-col-head" data-kb-tooltip="Backlog (バックログ): All agreed specs waiting to be started. WIP limit is not enforced here - pile it up.">
  Backlog
  <span class="kb-tip-icon">?</span>
</div>
<div class="kb-cards">
  <div class="kb-card kb-card-blue">
    <div class="kb-card-title">Auth endpoint spec</div>
    <div class="kb-card-meta">spec · task-042</div>
    <div class="kb-dots"><span class="kb-dot kb-red"></span><span class="kb-dot kb-red"></span><span class="kb-dot kb-red"></span></div>
  </div>
  <div class="kb-card kb-card-blue">
    <div class="kb-card-title">Rate limiter</div>
    <div class="kb-card-meta">spec · task-043</div>
    <div class="kb-dots"><span class="kb-dot kb-red"></span><span class="kb-dot kb-red"></span></div>
  </div>
</div>
</div>

<div class="kb-col">
<div class="kb-col-head" data-kb-tooltip="In Progress (進行中): Active implementation. WIP limit: 3. Exceeding the limit triggers Andon - the line stops until a slot opens. One-piece flow (一個流).">
  In Progress
  <span class="kb-tip-icon">?</span>
</div>
<div class="kb-cards">
  <div class="kb-card kb-card-yellow">
    <div class="kb-card-title">Login UI</div>
    <div class="kb-card-meta">impl · task-039</div>
    <div class="kb-dots"><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span><span class="kb-dot kb-yellow"></span></div>
  </div>
</div>
</div>

<div class="kb-col">
<div class="kb-col-head" data-kb-tooltip="Review (レビュー): Implementation done, tests green. Waiting for acceptance check and 5S cleanup (Seiso - 清掃). WIP limit: 2.">
  Review
  <span class="kb-tip-icon">?</span>
</div>
<div class="kb-cards">
  <div class="kb-card kb-card-purple">
    <div class="kb-card-title">DB schema migration</div>
    <div class="kb-card-meta">review · task-037</div>
    <div class="kb-dots"><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span></div>
  </div>
</div>
</div>

<div class="kb-col">
<div class="kb-col-head" data-kb-tooltip="Done (完了): All tests green, acceptance logged, docs written. Merged to main. Kaizen complete - 改善.">
  Done
  <span class="kb-tip-icon">?</span>
</div>
<div class="kb-cards">
  <div class="kb-card kb-card-green">
    <div class="kb-card-title">User profile page</div>
    <div class="kb-card-meta">done · task-035</div>
    <div class="kb-dots"><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span></div>
  </div>
  <div class="kb-card kb-card-green">
    <div class="kb-card-title">API rate metrics</div>
    <div class="kb-card-meta">done · task-036</div>
    <div class="kb-dots"><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span></div>
  </div>
</div>
</div>

</div><!-- .kb-board -->
</div><!-- .ks-kanban -->

</div><!-- .ks-home -->

<style>
.ks-home {
  max-width: 1152px;
  margin: 0 auto;
  padding: 0 1.5rem 4rem;
}

/* Top section: cards + install sidebar */
.ks-top {
  display: grid;
  grid-template-columns: 1fr 280px;
  gap: 2rem;
  align-items: start;
  padding: 2.5rem 0 2rem;
  border-top: 1px solid var(--vp-c-divider);
}

@media (max-width: 900px) {
  .ks-top { grid-template-columns: 1fr; }
}

/* Feature cards grid */
.ks-cards {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
}

@media (max-width: 600px) {
  .ks-cards { grid-template-columns: 1fr; }
}

.ks-card {
  display: flex;
  gap: 0.75rem;
  padding: 1.1rem 1.2rem;
  border: 1px solid var(--vp-c-divider);
  border-radius: 10px;
  background: var(--vp-c-bg-soft);
  transition: border-color 0.2s, box-shadow 0.2s;
}

.ks-card:hover {
  border-color: var(--vp-c-brand-1);
  box-shadow: 0 2px 12px rgba(0,0,0,0.08);
}

.ks-card-icon {
  font-size: 1.5rem;
  line-height: 1;
  flex-shrink: 0;
  margin-top: 2px;
}

.ks-card-body h3 {
  font-size: 0.95rem;
  font-weight: 700;
  margin: 0 0 0.35rem;
  color: var(--vp-c-text-1);
}

.ks-card-body p {
  font-size: 0.85rem;
  line-height: 1.55;
  color: var(--vp-c-text-2);
  margin: 0;
}

/* Install sidebar */
.ks-install {
  position: sticky;
  top: 6rem;
  padding: 1.25rem 1.4rem;
  border: 1px solid var(--vp-c-brand-1);
  border-radius: 10px;
  background: var(--vp-c-bg-soft);
}

.ks-install h3 {
  font-size: 1rem;
  font-weight: 700;
  margin: 0 0 0.75rem;
}

.ks-install div[class*="language-"] {
  margin: 0.5rem 0 0.75rem;
  font-size: 0.82rem;
}

.ks-install p {
  font-size: 0.85rem;
  color: var(--vp-c-text-2);
  margin: 0 0 0.75rem;
}

.ks-install-link {
  display: inline-block;
  font-size: 0.85rem;
  color: var(--vp-c-brand-1);
  text-decoration: none;
  font-weight: 600;
}

.ks-install-link:hover { text-decoration: underline; }

/* Kanban mock section */
.ks-kanban {
  border-top: 1px solid var(--vp-c-divider);
  padding-top: 2rem;
}

.ks-kanban h2 {
  font-size: 1.3rem;
  font-weight: 700;
  margin: 0 0 1.25rem;
}

.kb-board {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 0.85rem;
}

@media (max-width: 700px) {
  .kb-board { grid-template-columns: repeat(2, 1fr); }
}

.kb-col {
  background: var(--vp-c-bg-soft);
  border: 1px solid var(--vp-c-divider);
  border-radius: 8px;
  overflow: visible;
}

.kb-col-head {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.6rem 0.75rem;
  font-size: 0.8rem;
  font-weight: 700;
  background: var(--vp-c-bg-elv);
  border-bottom: 1px solid var(--vp-c-divider);
  border-radius: 8px 8px 0 0;
  cursor: help;
  user-select: none;
}

.kb-tip-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 14px;
  height: 14px;
  border-radius: 50%;
  background: var(--vp-c-text-3);
  color: var(--vp-c-bg);
  font-size: 9px;
  font-weight: 700;
  flex-shrink: 0;
}

/* Hover tooltip via data-kb-tooltip */
.kb-col-head::after {
  content: attr(data-kb-tooltip);
  position: absolute;
  top: calc(100% + 6px);
  left: 0;
  z-index: 100;
  width: 220px;
  padding: 8px 10px;
  border-radius: 6px;
  background: rgba(13,17,23,0.93);
  color: #e6edf3;
  font-size: 11px;
  font-weight: 400;
  line-height: 1.5;
  white-space: normal;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.18s;
  border: 1px solid #30363d;
}

.kb-col-head:hover::after { opacity: 1; }

.kb-cards {
  padding: 0.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  min-height: 80px;
}

.kb-card {
  padding: 0.5rem 0.6rem;
  border-radius: 6px;
  border-left: 3px solid transparent;
  background: var(--vp-c-bg);
  border-top: 1px solid var(--vp-c-divider);
  border-right: 1px solid var(--vp-c-divider);
  border-bottom: 1px solid var(--vp-c-divider);
}

.kb-card-blue   { border-left-color: #3b82f6; }
.kb-card-yellow { border-left-color: #f59e0b; }
.kb-card-purple { border-left-color: #8b5cf6; }
.kb-card-green  { border-left-color: #10b981; }

.kb-card-title {
  font-size: 0.78rem;
  font-weight: 600;
  color: var(--vp-c-text-1);
  margin-bottom: 2px;
}

.kb-card-meta {
  font-size: 0.7rem;
  color: var(--vp-c-text-3);
  margin-bottom: 4px;
}

.kb-dots { display: flex; gap: 3px; }

.kb-dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
}

.kb-red    { background: #ef4444; }
.kb-yellow { background: #f59e0b; }
.kb-green  { background: #10b981; }
</style>
