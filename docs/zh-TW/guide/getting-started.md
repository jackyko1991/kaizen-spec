# 快速入門

**文件說明網站：** [jackyko1991.github.io/kaizen-spec](https://jackyko1991.github.io/kaizen-spec/)
**GitHub：** [github.com/jackyko1991/kaizen-spec](https://github.com/jackyko1991/kaizen-spec)

本指南將引導您完成 kaizen-spec 的安裝，並執行您的第一次 `/kaizen-spec` 工作階段。

---

## 前置條件

- 已安裝 [Claude Code](https://claude.ai/code)（CLI 或 VS Code 擴充功能）
- Git
- Node.js 18+（僅在您需要在本地執行 VitePress 文件網站時才需要）

---

## 安裝

### 選項 A — curl 一行指令（建議）

最快速的安裝方式。在終端機中執行：

```bash
curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/install.sh | bash
```

這會下載並執行 `install.sh`，自動將 `kaizen-spec.md` 安裝至 `~/.claude/commands/`。

若您不希望從網路直接管線執行腳本，可以直接下載技能檔案：

```bash
curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/.claude/commands/kaizen-spec.md \
  > ~/.claude/commands/kaizen-spec.md
```

日後需要升級時，重新執行相同指令即可。Claude Code 會自動將 `~/.claude/commands/` 中的任何 `.md` 檔案識別為斜線指令。

---

## 驗證安裝

在 Claude Code 中開啟任意專案，然後輸入：

```
/kaizen-spec
```

若安裝正確，技能將啟動第一階段並詢問您：「這個功能要解決的核心問題是什麼，或它新增了什麼？」

若找不到指令，請確認 `~/.claude/commands/kaizen-spec.md` 是否存在：

```bash
ls -la ~/.claude/commands/kaizen-spec.md
```

---

## 第一次執行

1. 在 Claude Code 中開啟一個專案——任何專案、任何語言皆可。
2. 輸入 `/kaizen-spec`，描述您想要建置的內容（或留空並回答引導問題）。
3. 回答第一階段的對齊問題。請花足夠時間——這是最重要的階段。
4. 在第二階段確認測試框架。
5. 觀察第三階段：在瀏覽器中開啟 `.kaizen/board.html` 即可即時查看智能體的進度。
6. 第四和第五階段將自動完成。

整個週期——從規格到可運行、已測試、已記錄的程式碼——通常需要 15 至 45 分鐘，視功能複雜度而定。

---

## 在本地執行文件網站

```bash
cd ~/.claude/skills/kaizen-spec
npm install
npm run docs:dev
```

然後在瀏覽器中開啟 `http://localhost:5173`。

---

## 自我託管測試（進階）

安裝測試的終極考驗：使用 kaizen-spec 來開發 kaizen-spec 本身。

```bash
cd ~/.claude/skills/kaizen-spec
# 在 Claude Code 中開啟，然後執行：
/kaizen-spec "add a kaizen-log tail command that shows the last N entries"
```

若五個階段全部完成，且看板顯示所有卡片都在「完成」欄，則表示安裝運作正常。完整的自我託管驗收條件，請參閱 [checklist.md](https://github.com/jackyko/kaizen-spec/blob/main/features/kaizen-spec/checklist.md) 第六階段。

---

## 更新

若您使用選項 B（符號連結）安裝：

```bash
cd ~/.claude/skills/kaizen-spec
git pull
```

符號連結表示 Claude Code 會立即取用更新後的技能，無需重新連結。

---

## 解除安裝

```bash
rm ~/.claude/commands/kaizen-spec.md
# 可選：
rm -rf ~/.claude/skills/kaizen-spec
```

---

## 疑難排解

**在 Claude Code 中找不到 `/kaizen-spec`**

檢查指令目錄：
```bash
ls ~/.claude/commands/
```
`kaizen-spec.md` 檔案必須存在。若使用符號連結，請確認其可正確解析：
```bash
readlink -f ~/.claude/commands/kaizen-spec.md
```

**技能已啟動，但未使用 `AskUserQuestion`**

這表示 Claude Code 正在不支援互動式工具使用的上下文中執行（例如非互動式管線）。請從 Claude Code 互動工作階段中執行，而非從腳本執行。

**`.kaizen/board.html` 未自動重新載入**

看板每 5 秒輪詢 `location.reload()`。請確認您是直接在瀏覽器中開啟該檔案（使用 file:// 或本地 HTTP 伺服器），而非在封鎖 JavaScript 的預覽面板中開啟。

**測試在實作前就通過（第二階段警告）**

技能在此處刻意停止。這表示：
- 測試的對象有誤（空洞測試）
- 功能已部分存在

請閱讀測試輸出，修正測試使其確實失敗，然後重新執行第二階段。
