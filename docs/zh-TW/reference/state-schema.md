# 狀態結構定義

所有 kaizen-spec 狀態都儲存在專案根目錄的 `.kaizen/` 中。每個檔案都由 git 追蹤。Agent 僅從這些檔案重建完整上下文——不需要共享記憶體。

---

## 目錄結構

```
.kaizen/
  spec.md           — 已達成共識的功能規格（在第一階段撰寫）
  test-strategy.md  — 測試框架 + 失敗測試清單（在第二階段撰寫）
  tasks.json        — 任務清單、狀態、WIP 限制（在第三階段撰寫）
  board.html        — 即時看板（在第三階段全程更新）
  kaizen.log        — syslog 格式事件日誌（全程追加）
```

---

## `tasks.json`

```json
{
  "feature": "string — 規格中的功能名稱",
  "spec_committed": "ISO8601 時間戳 | null",
  "tasks": [
    {
      "id": "string — 例如 task-001",
      "title": "string — 簡短的人類可讀任務標題",
      "phase": "spec | test | impl | acceptance | docs",
      "status": "backlog | in-progress | blocked | done",
      "agent": "string | null — 認領時的 agent 識別符",
      "wip_column": "backlog | in-progress | review | done",
      "blocked_reason": "string | null — 若 status=blocked 則為純文字原因",
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

### 欄位說明

| 欄位 | 說明 |
|---|---|
| `id` | 在整個執行過程中保持穩定。絕不重複使用 ID。 |
| `status` | `blocked` 是 `in-progress` 的子狀態——agent 已認領任務但無法繼續。 |
| `wip_column` | 反映 `status` 但追蹤看板欄位。通常與 `status` 相同。 |
| `blocked_reason` | 當 `status=blocked` 時為必填項。純文字，無長度限制。 |
| `wip_limits` | 修改這些以調整並行程度。修改後重新啟動第三階段。 |

### 原子寫入

Agent 必須原子性地寫入 `tasks.json` 以避免並行存取時的損壞：

```bash
# 寫入暫存檔，然後重新命名（在 Linux/macOS 上為原子操作）
cp .kaizen/tasks.json .kaizen/tasks.json.bak
# ... 在記憶體中修改 ...
cat > .kaizen/tasks.json.tmp << 'EOF'
{ ... 更新後的內容 ... }
EOF
mv .kaizen/tasks.json.tmp .kaizen/tasks.json
```

---

## `spec.md`

由協調者在第一階段結束時撰寫。自由格式的 Markdown，但必須包含以下章節：

| 章節 | 必填 | 用途 |
|---|---|---|
| `## Intent` | 是 | 一段話：這解決什麼問題 |
| `## Target Output` | 是 | 具體的交付物 |
| `## In Scope` | 是 | 功能將做什麼 |
| `## Out of Scope` | 是 | 功能明確不做什麼 |
| `## Risks / Unknowns` | 是 | 已知的依賴項或不確定因素 |
| `## Acceptance Criterion` | 是 | 必須參照 `test-strategy.md` |

---

## `test-strategy.md`

由測試撰寫 agent 在第二階段結束時撰寫。必須包含：

| 章節 | 必填 | 用途 |
|---|---|---|
| 框架 + 安裝命令 | 是 | 可重現的測試設置 |
| 執行命令 | 是 | 執行所有測試的精確命令 |
| 測試清單表格 | 是 | 每個測試一行：名稱、涵蓋內容、檔案路徑 |
| 狀態行 | 是 | 實作前為「所有失敗（紅色）✓」 |

---

## `board.html`

獨立的 HTML 檔案。無需建置步驟。直接從檔案系統或任何靜態 HTTP 伺服器提供服務。

Agent 使用的關鍵 HTML 屬性：

| 屬性 | 元素 | 用途 |
|---|---|---|
| `data-status` | `.column-body` | 識別欄位（backlog、in-progress、review、done） |
| `data-wip-limit` | `.column-body` | 此欄位的 WIP 上限（0 = 無限制） |
| `data-task-id` | `.kaizen-card` | 將卡片連結至 `tasks.json` 任務 ID |
| `data-blocked` | `.kaizen-card` | `"true"` 觸發安燈徽章渲染 |

詳見 [看板](/zh-TW/guide/kanban)。
