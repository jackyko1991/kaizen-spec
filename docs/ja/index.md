---
layout: home

hero:
  name: kaizen-spec
  text: リーン優先のエージェンティック開発
  tagline: トヨタ生産方式の原則を AI エージェントワークフローに適用。遅い決断。品質を内蔵。近道なし。
  actions:
    - theme: brand
      text: はじめる
      link: /ja/guide/getting-started
    - theme: alt
      text: GitHub で見る
      link: https://github.com/jackyko1991/kaizen-spec
---

<div class="ks-home">

<div class="ks-top">
<div class="ks-cards">

<div class="ks-card">
<div class="ks-card-icon">📋</div>
<div class="ks-card-body">
<h3>常に仕様から始める</h3>
<p>すべての機能は構造化されたアラインメント質問から始まります。仕様が git にコミットされるまで、エージェントはコードを書きません。<strong>後決め</strong> - 最後責任時刻に決定し、最初の衝動の瞬間ではありません。</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">🔴</div>
<div class="ks-card-body">
<h3>テストを赤から緑へ</h3>
<p>実装前に失敗するテストを書きます。スキルはそれらが赤であることを確認します。すべて緑になるまで受け入れはブロックされます。<strong>自働化（Jidoka）</strong> - 欠陥を発見したら即座にラインを止める。</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">🔢</div>
<div class="ks-card-body">
<h3>WIP 制限 + 一個流れ</h3>
<p>かんばんボードが仕掛品制限を強制します。タスクはバックログから完了まで一つずつ移動します - バッチなし、マルチタスクなし。速さではなくフローで<strong>ムダ排除</strong>。</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">🏭</div>
<div class="ks-card-body">
<h3>リーン開発 / TPS</h3>
<p>トヨタ生産方式の上に構築：ムダ（浪費排除）、自働化（品質内蔵）、改善（継続的改善）、平準化（水準負荷）、現地現物（直接見に行く）。すべての実践が実証済みの TPS 概念に直接対応しています。</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">📊</div>
<div class="ks-card-body">
<h3>かんばんワークフロー</h3>
<p>ライブ HTML かんばんボードが WIP 制限、アンドン警報ブロッカーフラグ、自動リロードつきでエージェントの進捗を追跡します。タスクを列をまたいでドラッグし、リアルタイムでボードが更新されるのを見てください。</p>
</div>
</div>

<div class="ks-card">
<div class="ks-card-icon">📁</div>
<div class="ks-card-body">
<h3>標準作業 + コンテキストリセットに強い</h3>
<p>すべての状態は git 管理ファイルに保存されます。エージェントはゼロから再起動しても、中断した場所から正確に再開できます。<strong>標準作業（標準作業）</strong> - すべての行動が文書化され、再現可能で、監査可能です。</p>
</div>
</div>

</div><!-- .ks-cards -->

<aside class="ks-install">
<h3>インストール</h3>

```bash
curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/install.sh | bash
```

インストール後、任意のプロジェクトで Claude Code を開き、`/kaizen-spec` と入力してください。

<a href="/ja/guide/getting-started" class="ks-install-link">完全インストールガイド →</a>
</aside>
</div><!-- .ks-top -->

<div class="ks-kanban">
<h2>仕組み - ライブボード</h2>

<div class="kb-board">

<div class="kb-col">
<div class="kb-col-head" data-kb-tooltip="バックログ（Backlog）：開始を待つすべての合意済み仕様。ここでは WIP 制限は適用されません - どんどん積み上げてください。">
  バックログ
  <span class="kb-tip-icon">?</span>
</div>
<div class="kb-cards">
  <div class="kb-card kb-card-blue">
    <div class="kb-card-title">認証エンドポイント仕様</div>
    <div class="kb-card-meta">spec · task-042</div>
    <div class="kb-dots"><span class="kb-dot kb-red"></span><span class="kb-dot kb-red"></span><span class="kb-dot kb-red"></span></div>
  </div>
  <div class="kb-card kb-card-blue">
    <div class="kb-card-title">レートリミッター</div>
    <div class="kb-card-meta">spec · task-043</div>
    <div class="kb-dots"><span class="kb-dot kb-red"></span><span class="kb-dot kb-red"></span></div>
  </div>
</div>
</div>

<div class="kb-col">
<div class="kb-col-head" data-kb-tooltip="進行中（In Progress）：アクティブな実装。WIP 制限：3。制限を超えるとアンドンが発動 - スロットが開くまでラインが止まります。一個流れ（一個流れ）。">
  進行中
  <span class="kb-tip-icon">?</span>
</div>
<div class="kb-cards">
  <div class="kb-card kb-card-yellow">
    <div class="kb-card-title">ログイン UI</div>
    <div class="kb-card-meta">impl · task-039</div>
    <div class="kb-dots"><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span><span class="kb-dot kb-yellow"></span></div>
  </div>
</div>
</div>

<div class="kb-col">
<div class="kb-col-head" data-kb-tooltip="レビュー（Review）：実装完了、テスト通過。受け入れチェックと 5S 清掃（Seiso - 清掃）を待っています。WIP 制限：2。">
  レビュー
  <span class="kb-tip-icon">?</span>
</div>
<div class="kb-cards">
  <div class="kb-card kb-card-purple">
    <div class="kb-card-title">DB スキーママイグレーション</div>
    <div class="kb-card-meta">review · task-037</div>
    <div class="kb-dots"><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span></div>
  </div>
</div>
</div>

<div class="kb-col">
<div class="kb-col-head" data-kb-tooltip="完了（Done）：すべてのテスト通過、受け入れ記録済み、ドキュメント作成済み。メインにマージ。改善完了 - 改善。">
  完了
  <span class="kb-tip-icon">?</span>
</div>
<div class="kb-cards">
  <div class="kb-card kb-card-green">
    <div class="kb-card-title">ユーザープロフィールページ</div>
    <div class="kb-card-meta">done · task-035</div>
    <div class="kb-dots"><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span><span class="kb-dot kb-green"></span></div>
  </div>
  <div class="kb-card kb-card-green">
    <div class="kb-card-title">API レートメトリクス</div>
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
