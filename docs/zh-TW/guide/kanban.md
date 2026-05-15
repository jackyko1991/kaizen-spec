# 看板

kaizen-spec 在第 3 階段（實作）生成一個即時看板，位於 `.kaizen/board.html`，反映所有正在處理你功能的 agents 的即時狀態。

---

## 開啟看板

第 3 階段開始後，在任何瀏覽器中開啟 `.kaizen/board.html`。看板每 5 秒自動重新載入，反映 agents 的最新更新。

使用 VS Code Live Server 或 Python 內建 HTTP 伺服器可獲得更流暢的重新載入體驗：

```bash
# Option 1: Python
python3 -m http.server 8080 --directory .kaizen
# then open http://localhost:8080/board.html

# Option 2: VS Code Live Server extension
# Right-click board.html → "Open with Live Server"
```

---

## 欄位說明

| 欄位 | 意義 | WIP 限制 |
|---|---|---|
| Backlog | 尚未開始的任務 | 無 |
| In Progress | Agents 正在主動處理 | **3** |
| Review | 等待審查或合併 | **2** |
| Done | 已完成且測試通過 | 無 |

卡片隨 agents 進度由左向右移動。你也可以手動拖曳卡片——WIP 限制在用戶端強制執行。

---

## WIP 限制（豐田看板）

WIP 代表「在製品」（Work In Progress）。限制 WIP 是豐田看板的核心原則：同時進行較少的事情，意味著每件事能更快完成且錯誤更少。

**你會看到：** 當某欄位達到限制時，欄位標題會變為**紅色**。無法再拖入新的卡片。Agents 在認領新任務前會先查看 `tasks.json`——若已達限制，則等待。

**為何 In Progress 限制為 3？** 三個並行 agents 是並行性與協調開銷之間的預設平衡點。你可以修改 `.kaizen/tasks.json` 中的 `wip_limits` 來調整。

---

## 安燈繩——被阻塞的 Agents

在豐田工廠，任何工人在發現問題時都可以拉下「安燈繩」來停止生產線。kaizen-spec 有對應的機制。

**你會看到：** 被阻塞的卡片顯示紅色的 **⚠ BLOCKED** 徽章與 `border-danger` 外框。

**發生了什麼：** Agent 遇到了無法獨自解決的問題——缺少依賴項、規格不明確、外部 API 無法連接。它已經：
1. 將 `blocked_reason` 寫入 `.kaizen/tasks.json`
2. 在看板卡片上設定安燈標誌
3. 在 `.kaizen/kaizen.log` 中記錄一筆 `WARN` 條目
4. 停止工作並等待

**你需要做：** 讀取 `tasks.json` 或 `kaizen.log` 中的 `blocked_reason`，解決問題後，將任務狀態更新回 `in-progress`。技能會在設定阻塞時通知你。

---

## 改善日誌

位於 `.kaizen/kaizen.log` 的改善日誌是技能執行期間所有事件的只增不減記錄，採用 syslog 格式——每個事件一行結構化記錄。

```
2026-05-14T10:23:45Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=started
2026-05-14T10:31:02Z WARN [kaizen] phase=implementation task=task-001 agent=subagent-1 status=blocked reason="SortableJS CDN unreachable"
2026-05-14T10:35:18Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=unblocked duration=256s
2026-05-14T10:48:33Z INFO [kaizen] phase=implementation task=task-001 agent=subagent-1 status=done duration=1488s
```

執行後讀取日誌可發現規律：agents 在哪裡卡住？哪些階段耗時最長？日誌是機器可讀格式，因此可以使用 `grep`、`awk` 或將其導入任何日誌工具。

請參閱[改善日誌格式](/zh-TW/reference/kaizen-log)以取得完整規格。

---

## 主題

看板會自動遵循你的作業系統深色/淺色偏好。使用右上角的 **◐ Theme** 切換鈕可手動切換。你的偏好會儲存在 `localStorage` 中。
