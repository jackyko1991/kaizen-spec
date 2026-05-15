---
layout: home

hero:
  name: kaizen-spec
  text: 精實優先的智能代理開發Skills
  tagline: 豐田生產系統原則應用於 AI 智能代理工作流程。延遲決策。內建品質。沒有捷徑。
  actions:
    - theme: brand
      text: 快速入門
      link: /zh-TW/guide/getting-started
    - theme: alt
      text: 在 GitHub 上查看
      link: https://github.com/jackyko1991/kaizen-spec
---

<div class="ks-home">

<div class="ks-top">
<div class="ks-cards">

<div class="ks-card">
<div class="ks-card-icon">📋</div>
<div class="ks-card-body">
<h3>規格優先，始終如一</h3>
<p>每個功能都從結構化的對齊問題開始。在規格提交至 git 之前，智能代理不會撰寫任何程式碼。<strong>延遲決策</strong> - 在最後責任時刻決定，而非第一個衝動時刻。</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">🔴</div>
<div class="ks-card-body">
<h3>測試先紅後綠</h3>
<p>實作開始前先撰寫失敗的測試。技能確認它們是紅燈。直到全部變為綠燈才允許驗收。<strong>自働化（Jidoka）</strong> - 一發現缺陷即停線。</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">🔢</div>
<div class="ks-card-body">
<h3>WIP 限制 + 一個流</h3>
<p>看板強制執行在製品限制。任務從待辦到完成逐一移動，不批量、不多工。透過流動而非速度實現<strong>無駄消除</strong>。</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">🏭</div>
<div class="ks-card-body">
<h3>精實開發 / TPS</h3>
<p>建立在豐田生產系統之上：無駄（消除浪費）、自働化（內建品質）、改善（持續改進）、平準化（水平負載）、現地現物（親自去看）。每項實踐都直接對應經過驗證的 TPS 概念。</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">📊</div>
<div class="ks-card-body">
<h3>看板工作流程</h3>
<p>即時 HTML 看板追蹤智能代理進度，包含 WIP 限制、安燈封鎖旗標以及自動重新載入。拖曳任務跨欄，即時觀看看板更新。</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">📁</div>
<div class="ks-card-body">
<h3>標準作業 + 容忍全新上下文</h3>
<p>所有狀態都存放在 git 追蹤的檔案中。智能體從零開始，並從上次中斷的地方繼續。<strong>標準作業（標準作業）</strong> - 每個動作都有文件記錄、可重複且可稽核。</p>
</div>
</div>

</div><!-- .ks-cards -->

<aside class="ks-install">
<h3>安裝</h3>

```bash
curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/install.sh | bash
```

安裝完成後，在任意專案中開啟 Claude Code 並輸入 `/kaizen-spec`。

<a href="/zh-TW/guide/getting-started" class="ks-install-link">完整安裝指南 →</a>
</aside>
</div><!-- .ks-top -->

<div class="ks-kanban">
<h2>運作方式 - 即時看板</h2>

<div class="kb-board">

<div class="kb-col">
<div class="kb-col-head" data-kb-tooltip="待辦（Backlog）：所有已同意的規格等待開始。此處不強制執行 WIP 限制 - 盡量堆積。">
  待辦
  <span class="kb-tip-icon">?</span>
</div>
<div class="kb-cards">
  <div class="kb-card kb-card-blue">
    <div class="kb-card-title">認證端點規格</div>
    <div class="kb-card-meta">spec · task-042</div>
    <div class="kb-dots"><span class="kb-dot kb-red"></span><span class="kb-dot kb-red"></span><span class="kb-dot kb-red"></span></div>
  </div>
  <div class="kb-card kb-card-blue">
    <div class="kb-card-title">速率限制器</div>
    <div class="kb-card-meta">spec · task-043</div>
    <div class="kb-dots"><span class="kb-dot kb-red"></span><span class="kb-dot kb-red"></span></div>
  </div>
</div>
</div>

<div class="kb-col">
<div class="kb-col-head" data-kb-tooltip="進行中（In Progress）：主動實作。WIP 限制：3。超過限制觸發安燈 - 線路停止直到有空位。一個流（一個流）。">
  進行中
  <span class="kb-tip-icon">?</span>
</div>
<div class="kb-cards">
  <div class="kb-card kb-card-yellow">
    <div class="kb-card-title">登入介面</div>
    <div class="kb-card-meta">impl · task-039</div>
    <div class="kb-dots"><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span><span class="kb-dot kb-yellow"></span></div>
  </div>
</div>
</div>

<div class="kb-col">
<div class="kb-col-head" data-kb-tooltip="審查（Review）：實作完成，測試通過。等待驗收檢查和 5S 清掃（Seiso - 清掃）。WIP 限制：2。">
  審查
  <span class="kb-tip-icon">?</span>
</div>
<div class="kb-cards">
  <div class="kb-card kb-card-purple">
    <div class="kb-card-title">資料庫結構遷移</div>
    <div class="kb-card-meta">review · task-037</div>
    <div class="kb-dots"><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span></div>
  </div>
</div>
</div>

<div class="kb-col">
<div class="kb-col-head" data-kb-tooltip="完成（Done）：所有測試通過，驗收已記錄，文件已撰寫。合併至主分支。改善完成 - 改善。">
  完成
  <span class="kb-tip-icon">?</span>
</div>
<div class="kb-cards">
  <div class="kb-card kb-card-green">
    <div class="kb-card-title">使用者個人頁面</div>
    <div class="kb-card-meta">done · task-035</div>
    <div class="kb-dots"><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span></div>
  </div>
  <div class="kb-card kb-card-green">
    <div class="kb-card-title">API 速率指標</div>
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
