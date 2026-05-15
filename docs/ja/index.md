---
layout: home

hero:
  name: kaizen-spec
  text: 仕様駆動のアジェンティック開発
  tagline: 仕様が合意されるまでコードを書かない。テストが通るまで「完了」にしない。近道なし。
  actions:
    - theme: brand
      text: はじめる
      link: /guide/getting-started
    - theme: alt
      text: GitHub で見る
      link: https://github.com/jackyko/kaizen-spec

features:
  - title: 常に仕様から始める
    details: すべての機能はアラインメント質問から始まります。仕様が git にコミットされるまで、エージェントはコードを書きません。
  - title: TDD を強制する
    details: 実装前に失敗するテストを書きます。スキルはそれらが赤であることを確認します。すべて緑になるまで受け入れはブロックされます。
  - title: セルフホスティング
    details: kaizen-spec は kaizen-spec 自身を使って開発されます。スキルが自分自身を開発できなければ、まだ完成していません。
  - title: トヨタかんばんボード
    details: ライブ HTML かんばんボードが WIP 制限・アンドン警報フラグ・自動リロードつきでエージェントの進捗を追跡します。
  - title: 継続的改善
    details: 実行のたびに syslog 形式で kaizen.log に追記されます。ブロッカー・サイクルタイム・状態遷移を記録し、パターンを見つけましょう。
  - title: コンテキストリセットに強い
    details: すべての状態は git 管理ファイルに保存されます。エージェントはゼロから再起動しても、中断した場所から正確に再開できます。
---

<div class="install-section">

## インストール

<div class="install-cols">
<div class="install-col">

**標準インストール** - スキルファイルを Claude Code にコピーします：

```bash
curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/install.sh | bash
```

インストール後、任意のプロジェクトで Claude Code を開き、`/kaizen-spec` と入力してください。

</div>
<div class="install-col">

**開発者モード** - リポジトリでの変更がすぐに反映されるシンボリックリンクを作成します：

```bash
git clone https://github.com/jackyko1991/kaizen-spec
cd kaizen-spec
make install-dev
```

アップグレード・アンインストール・トラブルシューティングは[完全インストールガイド](/ja/guide/getting-started)を参照してください。

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
