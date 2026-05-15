# 改善ログ形式

`.kaizen/kaizen.log`は追記専用のsyslog風構造化ログです。スキル実行中のすべての状態遷移がここに記録されます。

---

## 形式

```
YYYY-MM-DDTHH:MM:SSZ SEVERITY [kaizen] key=value key="quoted value if spaces"
```

- **タイムスタンプ**: ISO 8601、UTC、秒精度
- **重要度**: `INFO`、`WARN`、または`ERROR`（大文字）
- **タグ**: 常に`[kaizen]`
- **キーと値のペア**: スペース区切り、スペースを含む値は二重引用符で囲む

---

## 重要度レベル

| レベル | 使用タイミング |
|---|---|
| `INFO` | 通常の状態遷移：タスク開始、タスク完了、テスト合格 |
| `WARN` | 回復可能な問題：タスクブロック、WIP制限到達、テストが予期せず合格 |
| `ERROR` | 回復不可能な障害：受入失敗、仕様欠損 |

---

## 標準イベント

### タスク開始
```
2026-05-14T10:23:45Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=started
```

### タスク完了
```
2026-05-14T10:48:33Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=done duration=1488s
```

### タスクブロック（安燈コード）
```
2026-05-14T10:31:02Z WARN [kaizen] phase=implementation task=task-001 agent=subagent-1 status=blocked reason="SortableJS CDN unreachable"
```

### タスクのブロック解除
```
2026-05-14T10:35:18Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=unblocked duration=256s
```

### WIP制限到達
```
2026-05-14T10:25:00Z WARN [kaizen] column=in-progress limit=3 attempted_task=task-004 status=queued
```

### すべてのテスト失敗（フェーズ2完了）
```
2026-05-14T09:55:12Z INFO [kaizen] phase=test count=8 framework=playwright status=all-failing
```

### すべてのテスト合格（フェーズ4開始）
```
2026-05-14T11:02:44Z INFO [kaizen] phase=acceptance count=8 framework=playwright status=all-passing duration=4972s
```

### 受入失敗
```
2026-05-14T11:02:44Z ERROR [kaizen] phase=acceptance failed_count=2 reason="board WIP limit not enforced in Firefox"
```

### 仕様整合（フェーズ1完了）
```
2026-05-14T09:42:18Z INFO [kaizen] phase=spec feature="kanban-log-viewer" status=committed
```

### ドキュメント作成（フェーズ5完了）
```
2026-05-14T10:55:33Z INFO [kaizen] phase=docs feature="kanban-log-viewer" file="docs/guide/kanban-log-viewer.md" status=done
```

---

## 標準キー

| キー | 型 | 説明 |
|---|---|---|
| `phase` | 文字列 | `spec`、`test`、`implementation`、`acceptance`、`docs` |
| `task` | 文字列 | `tasks.json`のタスクID |
| `agent` | 文字列 | エージェント識別子 |
| `status` | 文字列 | `started`、`done`、`blocked`、`unblocked`、`failed`、`committed`、`all-failing`、`all-passing` |
| `duration` | 文字列 | 経過秒数、例：`1488s` |
| `reason` | 文字列 | 人間が読める説明（スペースを含む場合は引用符で囲む） |
| `count` | 整数 | テスト数 |
| `failed_count` | 整数 | 失敗したテスト数 |
| `framework` | 文字列 | 例：`playwright`、`pytest`、`vitest` |
| `column` | 文字列 | かんばん列名 |
| `limit` | 整数 | WIP制限値 |
| `attempted_task` | 文字列 | WIP制限によってブロックされたタスクID |
| `feature` | 文字列 | 機能名（スペースを含む場合は引用符で囲む） |
| `file` | 文字列 | ファイルパス |

---

## ログの読み方

### 実行中のすべてのブロックを見つける
```bash
grep 'status=blocked' .kaizen/kaizen.log
```

### 総サイクルタイムを計算する（仕様から受入まで）
```bash
head -1 .kaizen/kaizen.log   # 最初のエントリのタイムスタンプ
grep 'phase=acceptance.*status=all-passing' .kaizen/kaizen.log  # 受入タイムスタンプ
```

### エージェントごとに完了したタスク数をカウントする
```bash
grep 'status=done' .kaizen/kaizen.log | awk -F'agent=' '{print $2}' | awk '{print $1}' | sort | uniq -c
```

### すべてのエラーを表示する
```bash
grep '^.*ERROR' .kaizen/kaizen.log
```

---

## コンプライアンスモード

プロジェクトが規制標準（ISO 13485、IEC 62443、ISO 9001、FDA 21 CFR Part 11、DO-178C、IEC 61508など）の対象となる場合、`.kaizen/tasks.json`に`"compliance_mode": true`を設定します。その後、すべてのログ行にトレーサビリティ監査に必要な追加の構造化フィールドが付加されます。

### コンプライアンスモードの有効化

フェーズ1のQ5で**「規制/コンプライアンス要件」**を選択し、適用される標準と条項を指定します。オーケストレーターはそれらを仕様に記録し、フラグを設定します。

### 追加フィールド（コンプライアンスモードのみ）

| キー | 説明 | 例 |
|---|---|---|
| `requirement_id` | このイベントが満たす標準の条項 | `ISO13485-7.3.2`、`IEC62443-4-1-SD-2`、`DO178C-A.5` |
| `change_type` | 変更の性質 | `design-input`、`design-output`、`verification`、`validation`、`review`、`code-change` |
| `actor` | 作業を実行するエージェントID；人間の監督があった場合は`review:human`を追加 | `agent:subagent-1`、`agent:subagent-1 review:human` |
| `artifact` | 影響を受ける出力のファイルパスとgitコミットハッシュ | `spec.md@abc1234`、`src/auth.ts@def5678` |
| `justification` | 変更を促した要件へのポインタ | `spec.md#intent`、`tasks.json#task-003` |

### コンプライアンスフィールドは追加的です

標準のログコンシューマーは未知のキーを無視します——基本形式は変更されません。コンプライアンスを意識していない`kaizen.log`解析ツールは引き続き動作し、コンプライアンスを意識したツールはトレーサビリティレポート用の追加フィールドを取得します。

---

## 追記専用ルール

エージェントは既存の行を**決して**変更または削除しません。追記のみを行います。これにより、ログは完全で不変の実行記録となります——コミットしても安全、`git blame`しても安全、ログアグリゲーターにパイプしても安全、規制監査証跡として適切です。
