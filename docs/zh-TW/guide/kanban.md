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

<div class="kb-guide-cols">
<div class="kb-guide-col" data-kb-tooltip="待辦（Backlog）：所有已同意的規格等待開始。此處不強制執行 WIP 限制。任務在此等待直到進行中欄位有空位。">
  <strong>待辦</strong>
  <p>尚未開始的任務。無 WIP 限制。</p>
</div>
<div class="kb-guide-col" data-kb-tooltip="進行中（一個流）：主動實作。WIP 限制：3。超過限制觸發安燈 - 線路停止直到有空位。一個流防止多工浪費（無駄）。">
  <strong>進行中</strong>
  <p>Agents 正在主動處理。WIP 限制：<strong>3</strong>。</p>
</div>
<div class="kb-guide-col" data-kb-tooltip="審查（レビュー）：實作完成，測試通過。等待驗收檢查和 5S 清掃（Seiso - 清掃）。WIP 限制：2。">
  <strong>審查</strong>
  <p>等待審查或合併。WIP 限制：<strong>2</strong>。</p>
</div>
<div class="kb-guide-col" data-kb-tooltip="完成（完了 / 改善）：所有測試通過，驗收已記錄，文件已撰寫。合併至主分支。改善循環完成。">
  <strong>完成</strong>
  <p>已完成且測試通過。無 WIP 限制。</p>
</div>
</div>

卡片隨 agents 進度由左向右移動。你也可以手動拖曳卡片——WIP 限制在用戶端強制執行。

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
