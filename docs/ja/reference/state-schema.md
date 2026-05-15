# ステートスキーマ

kaizen-specのすべての状態はプロジェクトのルートにある`.kaizen/`に保存されます。すべてのファイルはgitで追跡されます。エージェントはこれらのファイルだけから完全なコンテキストを再構築します——共有メモリは不要です。

---

## ディレクトリ構成

```
.kaizen/
  spec.md           — 合意済みの機能仕様（フェーズ1で作成）
  test-strategy.md  — テストフレームワーク + 失敗テストリスト（フェーズ2で作成）
  tasks.json        — タスクリスト、状態、WIP制限（フェーズ3で作成）
  board.html        — ライブかんばんボード（フェーズ3全体を通じて更新）
  kaizen.log        — syslog形式のイベントログ（全体を通じて追記）
```

---

## `tasks.json`

```json
{
  "feature": "string — 仕様の機能名",
  "spec_committed": "ISO8601タイムスタンプ | null",
  "tasks": [
    {
      "id": "string — 例: task-001",
      "title": "string — 短い人間が読めるタスクタイトル",
      "phase": "spec | test | impl | acceptance | docs",
      "status": "backlog | in-progress | blocked | done",
      "agent": "string | null — 引き取り時のエージェント識別子",
      "wip_column": "backlog | in-progress | review | done",
      "blocked_reason": "string | null — status=blockedの場合のプレーンテキストの理由",
      "started_at": "ISO8601 | null",
      "completed_at": "ISO8601 | null"
    }
  ],
  "wip_limits": {
    "in-progress": 3,
    "review": 2
  }
}
```

### フィールドの注記

| フィールド | 注記 |
|---|---|
| `id` | 実行全体で安定しています。IDを再利用しないでください。 |
| `status` | `blocked`は`in-progress`のサブ状態です——エージェントはタスクを引き取りましたが、続行できません。 |
| `wip_column` | `status`を反映しますが、ボードの列を追跡します。通常は`status`と同じです。 |
| `blocked_reason` | `status=blocked`の時に必須です。プレーンテキスト、長さ制限なし。 |
| `wip_limits` | 並行性を調整するために変更します。変更後はフェーズ3を再開してください。 |

### アトミック書き込み

エージェントは並行アクセス下での破損を避けるため、`tasks.json`をアトミックに書き込む必要があります：

```bash
# 一時ファイルに書き込み、その後リネーム（Linux/macOSではアトミック）
cp .kaizen/tasks.json .kaizen/tasks.json.bak
# ... メモリ内で変更 ...
cat > .kaizen/tasks.json.tmp << 'EOF'
{ ... 更新された内容 ... }
EOF
mv .kaizen/tasks.json.tmp .kaizen/tasks.json
```

---

## `spec.md`

フェーズ1の終わりにオーケストレーターによって作成されます。自由形式のMarkdownですが、以下のセクションを含む必要があります：

| セクション | 必須 | 目的 |
|---|---|---|
| `## Intent` | はい | 1段落：これが解決する問題 |
| `## Target Output` | はい | 具体的な成果物 |
| `## In Scope` | はい | 機能が行うこと |
| `## Out of Scope` | はい | 明示的に行わないこと |
| `## Risks / Unknowns` | はい | 既知の依存関係や不確実性 |
| `## Acceptance Criterion` | はい | `test-strategy.md`を参照する必要があります |

---

## `test-strategy.md`

フェーズ2の終わりにテスト作成エージェントによって作成されます。以下を含む必要があります：

| セクション | 必須 | 目的 |
|---|---|---|
| フレームワーク + インストールコマンド | はい | 再現可能なテストセットアップ |
| 実行コマンド | はい | すべてのテストを実行する正確なコマンド |
| テストリスト表 | はい | テストごとに1行：名前、カバーする内容、ファイルパス |
| ステータス行 | はい | 実装前は「すべて失敗（レッド）✓」 |

---

## `board.html`

スタンドアロンのHTMLファイル。ビルドステップ不要。ファイルシステムまたは任意の静的HTTPサーバーから直接提供されます。

エージェントが使用する主要なHTML属性：

| 属性 | 要素 | 目的 |
|---|---|---|
| `data-status` | `.column-body` | 列を識別（backlog、in-progress、review、done） |
| `data-wip-limit` | `.column-body` | この列のWIP上限（0 = 無制限） |
| `data-task-id` | `.kaizen-card` | カードを`tasks.json`のタスクIDにリンク |
| `data-blocked` | `.kaizen-card` | `"true"`が安燈バッジのレンダリングをトリガー |

詳細は[かんばんボード](/ja/guide/kanban)を参照してください。
