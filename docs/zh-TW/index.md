---
layout: home

hero:
  name: kaizen-spec
  text: 規格驅動的智能體開發
  tagline: 規格未確認前不寫程式碼。測試未通過前不算完成。沒有捷徑。
  actions:
    - theme: brand
      text: 快速入門
      link: /zh-TW/guide/getting-started
    - theme: alt
      text: 在 GitHub 上查看
      link: https://github.com/jackyko/kaizen-spec

features:
  - title: 規格優先，始終如一
    details: 每個功能都從結構化的對齊問題開始。在規格提交至 git 之前，智能體不會撰寫任何程式碼。
  - title: 強制執行 TDD
    details: 測試在實作開始前先撰寫，且必須處於失敗狀態。技能會驗證它們都是紅燈。直到全部變為綠燈才允許進行驗收。
  - title: 自我託管
    details: kaizen-spec 使用 kaizen-spec 本身來進行開發。若技能無法開發自身，就代表尚未完成。
  - title: 豐田看板
    details: 即時 HTML 看板追蹤智能體進度，包含 WIP 限制、安燈警報封鎖旗標以及自動重新載入。
  - title: 持續改善
    details: 每次執行都會以 syslog 格式附加至 kaizen.log——記錄封鎖原因、循環時間與狀態轉換。閱讀日誌以發現規律。
  - title: 容忍全新上下文
    details: 所有狀態都存放在 git 追蹤的檔案中。智能體可以從零開始，並從上次中斷的地方繼續。
---

<div class="install-section">

## 安裝

<div class="install-cols">
<div class="install-col">

**標準安裝** - 將技能檔案複製到 Claude Code：

```bash
curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/install.sh | bash
```

安裝完成後，在任意專案中開啟 Claude Code 並輸入 `/kaizen-spec`。

</div>
<div class="install-col">

**開發者模式** - 建立符號連結，在 repo 中的修改立即生效：

```bash
git clone https://github.com/jackyko1991/kaizen-spec
cd kaizen-spec
make install-dev
```

詳見[完整安裝指南](/zh-TW/guide/getting-started)，包含升級、解除安裝與問題排解。

</div>
</div>

</div>

<style>
.install-section {
  max-width: 1152px;
  margin: 0 auto;
  padding: 2.5rem 1.5rem 3rem;
  border-top: 1px solid var(--vp-c-divider);
}

.install-section h2 {
  font-size: 1.6rem;
  font-weight: 700;
  margin-bottom: 1.5rem;
}

.install-cols {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
}

@media (max-width: 768px) {
  .install-cols { grid-template-columns: 1fr; }
}

.install-col p {
  margin: 0.4rem 0;
  color: var(--vp-c-text-2);
  font-size: 0.95rem;
}

.install-col div[class*="language-"] {
  margin: 0.4rem 0 0.8rem;
}
</style>
