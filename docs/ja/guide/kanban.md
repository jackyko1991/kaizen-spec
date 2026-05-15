# かんばんボード

kaizen-spec はフェーズ3で `.kaizen/board.html` にライブのかんばんボードを生成します。あなたの機能に取り組んでいるすべてのエージェントのリアルタイムの状態を反映します。

---

## ボードを開く

フェーズ3が始まったら、任意のブラウザで `.kaizen/board.html` を開いてください。エージェントが更新するたびに5秒ごとに自動リロードされます。

VS Code Live Server または Python の組み込み HTTP サーバーを使うと、よりスムーズにリロードできます：

```bash
# オプション1: Python
python3 -m http.server 8080 --directory .kaizen
# その後 http://localhost:8080/board.html を開く

# オプション2: VS Code Live Server 拡張機能
# board.html を右クリック → "Open with Live Server"
```

---

## カラム

<div class="kb-guide-cols">
<div class="kb-guide-col" data-kb-tooltip="バックログ（Backlog）：開始を待つすべての合意済み仕様。ここでは WIP 制限は適用されません。In Progress 欄にスロットが開くまでタスクはここで待機します。">
  <strong>バックログ</strong>
  <p>まだ開始されていないタスク。制限なし。</p>
</div>
<div class="kb-guide-col" data-kb-tooltip="進行中（一個流れ）：アクティブな実装。WIP 制限：3。制限を超えるとアンドンが発動 - スロットが開くまでラインが止まります。一個流れはマルチタスクの浪費（ムダ）を防ぎます。">
  <strong>進行中</strong>
  <p>エージェントが積極的に作業中。WIP制限：<strong>3</strong>。</p>
</div>
<div class="kb-guide-col" data-kb-tooltip="レビュー（Review）：実装完了、テスト通過。受け入れチェックと 5S 清掃（Seiso - 清掃）を待っています。WIP 制限：2。">
  <strong>レビュー</strong>
  <p>レビューまたはマージ待ち。WIP制限：<strong>2</strong>。</p>
</div>
<div class="kb-guide-col" data-kb-tooltip="完了（完了 / 改善）：すべてのテスト通過、受け入れ記録済み、ドキュメント作成済み。メインにマージ。改善サイクル完了。">
  <strong>完了</strong>
  <p>完了し、テストが通っている。制限なし。</p>
</div>
</div>

カードはエージェントの進捗に合わせて左から右へ移動します。カードを手動でドラッグすることもできます。WIP制限はクライアント側で強制されます。

<style>
.kb-guide-cols {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 0.75rem;
  margin: 1rem 0;
}
@media (max-width: 640px) {
  .kb-guide-cols { grid-template-columns: repeat(2, 1fr); }
}
.kb-guide-col {
  position: relative;
  padding: 0.75rem 1rem;
  border: 1px solid var(--vp-c-divider);
  border-radius: 8px;
  background: var(--vp-c-bg-soft);
  cursor: help;
}
.kb-guide-col p {
  font-size: 0.82rem;
  color: var(--vp-c-text-2);
  margin: 0.25rem 0 0;
}
.kb-guide-col::after {
  content: attr(data-kb-tooltip);
  position: absolute;
  bottom: calc(100% + 6px);
  left: 0;
  z-index: 100;
  width: 240px;
  padding: 8px 10px;
  border-radius: 6px;
  background: rgba(13,17,23,0.93);
  color: #e6edf3;
  font-size: 11px;
  line-height: 1.5;
  white-space: normal;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.18s;
  border: 1px solid #30363d;
}
.kb-guide-col:hover::after { opacity: 1; }
</style>

---

## WIP制限（トヨタかんばん）

WIPとは「仕掛品（Work In Progress）」の略です。WIPを制限することはトヨタかんばんの中核原則です。同時進行を減らすことで、各作業は速く、少ないミスで完了します。

**ボードの見え方：** カラムが上限に達すると、カラムのヘッダーが**赤**に変わります。新しいカードはドラッグできません。エージェントは新しいタスクを受け取る前に `tasks.json` を確認します。上限に達していれば、エージェントは待機します。

**「In Progress」がなぜ3なのか？** 3つの並列エージェントは、並列性と調整オーバーヘッドのバランスとしてデフォルトの設定です。`.kaizen/tasks.json` の `wip_limits` を変更して調整できます。

---

## アンドン・コード — ブロックされたエージェント

トヨタの工場では、作業者が問題に気づいたときに「アンドン・コード」を引いてラインを停止できます。kaizen-spec にも同等の機能があります。

**ボードの見え方：** ブロックされたカードには赤い **⚠ BLOCKED** バッジと `border-danger` のアウトラインが表示されます。

**何が起きたか：** エージェントが単独では解決できない問題に直面しました。依存関係の欠如、不明確な仕様、到達できない外部 API などです。エージェントは：
1. `blocked_reason` を `.kaizen/tasks.json` に書き込んだ
2. ボードカードにアンドンフラグをセットした
3. `.kaizen/kaizen.log` に `WARN` エントリをログした
4. 作業を止めて待機している

**あなたがすること：** `tasks.json` または `kaizen.log` の `blocked_reason` を読み、問題を解決して、タスクのステータスを `in-progress` に戻してください。ブロッカーがセットされると、スキルからあなたに通知されます。

---

## 改善ログ

`.kaizen/kaizen.log` の改善ログは、スキル実行中に起きたすべての出来事を記録する追記専用のログです。syslog フォーマットを使用し、1イベントにつき1行の構造化されたラインです。

```
2026-05-14T10:23:45Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=started
2026-05-14T10:31:02Z WARN [kaizen] phase=implementation task=task-001 agent=subagent-1 status=blocked reason="SortableJS CDN unreachable"
2026-05-14T10:35:18Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=unblocked duration=256s
2026-05-14T10:48:33Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=done duration=1488s
```

実行後にログを読んでパターンを見つけてください。どこでエージェントが詰まるか？どのフェーズが最も長くかかるか？ログは機械可読なので、`grep`・`awk`・任意のログツールにパイプできます。

完全な仕様については [改善ログのフォーマット](/ja/reference/kaizen-log) を参照してください。

---

## テーマ

ボードはOSのダーク/ライト設定を自動的に反映します。右上の **◐ Theme** トグルを使って手動で切り替えることもできます。設定は `localStorage` に保存されます。
