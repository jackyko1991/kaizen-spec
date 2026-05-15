# 改善日誌格式

`.kaizen/kaizen.log` 是一個僅能追加的、受 syslog 啟發的結構化日誌。技能執行期間的每一次狀態轉換都記錄於此。

---

## 格式

```
YYYY-MM-DDTHH:MM:SSZ SEVERITY [kaizen] key=value key="quoted value if spaces"
```

- **時間戳**：ISO 8601，UTC，秒精度
- **嚴重性**：`INFO`、`WARN` 或 `ERROR`（大寫）
- **標籤**：始終為 `[kaizen]`
- **鍵值對**：以空格分隔，含空格的值必須用雙引號括起來

---

## 嚴重性等級

| 等級 | 使用時機 |
|---|---|
| `INFO` | 正常狀態轉換：任務開始、任務完成、測試通過 |
| `WARN` | 可恢復的問題：任務受阻、WIP 限制達到、測試意外通過 |
| `ERROR` | 不可恢復的失敗：驗收失敗、規格缺失 |

---

## 標準事件

### 任務開始
```
2026-05-14T10:23:45Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=started
```

### 任務完成
```
2026-05-14T10:48:33Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=done duration=1488s
```

### 任務受阻（安燈繩）
```
2026-05-14T10:31:02Z WARN [kaizen] phase=implementation task=task-001 agent=subagent-1 status=blocked reason="SortableJS CDN unreachable"
```

### 任務解除阻礙
```
2026-05-14T10:35:18Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=unblocked duration=256s
```

### WIP 限制達到
```
2026-05-14T10:25:00Z WARN [kaizen] column=in-progress limit=3 attempted_task=task-004 status=queued
```

### 所有測試失敗（第二階段完成）
```
2026-05-14T09:55:12Z INFO [kaizen] phase=test count=8 framework=playwright status=all-failing
```

### 所有測試通過（第四階段開始）
```
2026-05-14T11:02:44Z INFO [kaizen] phase=acceptance count=8 framework=playwright status=all-passing duration=4972s
```

### 驗收失敗
```
2026-05-14T11:02:44Z ERROR [kaizen] phase=acceptance failed_count=2 reason="board WIP limit not enforced in Firefox"
```

### 規格對齊（第一階段完成）
```
2026-05-14T09:42:18Z INFO [kaizen] phase=spec feature="kanban-log-viewer" status=committed
```

### 文件完成（第五階段完成）
```
2026-05-14T10:55:33Z INFO [kaizen] phase=docs feature="kanban-log-viewer" file="docs/guide/kanban-log-viewer.md" status=done
```

---

## 標準鍵

| 鍵 | 類型 | 描述 |
|---|---|---|
| `phase` | 字串 | `spec`、`test`、`implementation`、`acceptance`、`docs` |
| `task` | 字串 | `tasks.json` 中的任務 ID |
| `agent` | 字串 | Agent 識別符 |
| `status` | 字串 | `started`、`done`、`blocked`、`unblocked`、`failed`、`committed`、`all-failing`、`all-passing` |
| `duration` | 字串 | 經過秒數，例如 `1488s` |
| `reason` | 字串 | 人類可讀的說明（若含空格則加引號） |
| `count` | 整數 | 測試數量 |
| `failed_count` | 整數 | 失敗測試數量 |
| `framework` | 字串 | 例如 `playwright`、`pytest`、`vitest` |
| `column` | 字串 | 看板欄位名稱 |
| `limit` | 整數 | WIP 限制值 |
| `attempted_task` | 字串 | 被 WIP 限制阻擋的任務 ID |
| `feature` | 字串 | 功能名稱（若含空格則加引號） |
| `file` | 字串 | 檔案路徑 |

---

## 讀取日誌

### 找出一次執行中的所有阻礙
```bash
grep 'status=blocked' .kaizen/kaizen.log
```

### 計算總週期時間（規格到驗收）
```bash
head -1 .kaizen/kaizen.log   # 第一個條目時間戳
grep 'phase=acceptance.*status=all-passing' .kaizen/kaizen.log  # 驗收時間戳
```

### 計算每個 agent 完成的任務數
```bash
grep 'status=done' .kaizen/kaizen.log | awk -F'agent=' '{print $2}' | awk '{print $1}' | sort | uniq -c
```

### 查看所有錯誤
```bash
grep '^.*ERROR' .kaizen/kaizen.log
```

---

## 合規模式

當專案受監管標準約束時（ISO 13485、IEC 62443、ISO 9001、FDA 21 CFR Part 11、DO-178C、IEC 61508 或類似標準），在 `.kaizen/tasks.json` 中設置 `"compliance_mode": true`。此後每條日誌行都會攜帶合規性稽核追蹤所需的額外結構化欄位。

### 啟用合規模式

在第一階段 Q5 中，選擇**「監管/合規要求」**並列出適用的標準及條款。協調者將其記錄在規格中並設置此旗標。

### 額外欄位（僅合規模式）

| 鍵 | 描述 | 範例 |
|---|---|---|
| `requirement_id` | 此事件滿足的標準條款 | `ISO13485-7.3.2`、`IEC62443-4-1-SD-2`、`DO178C-A.5` |
| `change_type` | 變更的性質 | `design-input`、`design-output`、`verification`、`validation`、`review`、`code-change` |
| `actor` | 執行工作的 Agent ID；當有人工監督時附加 `review:human` | `agent:subagent-1`、`agent:subagent-1 review:human` |
| `artifact` | 受影響輸出的檔案路徑和 git commit 雜湊 | `spec.md@abc1234`、`src/auth.ts@def5678` |
| `justification` | 指向促使此變更的需求 | `spec.md#intent`、`tasks.json#task-003` |

### 合規欄位是可加的

標準日誌消費者忽略未知鍵——基本格式不變。不具合規意識的 `kaizen.log` 解析工具繼續正常工作；具合規意識的工具獲得用於追蹤報告的額外欄位。

---

## 僅追加規則

Agent **絕不**修改或刪除現有行。它們只追加。這意味著日誌是完整的、不可變的執行記錄——可安全提交、可安全 `git blame`、可安全導入日誌聚合器，並適合作為監管稽核追蹤。
