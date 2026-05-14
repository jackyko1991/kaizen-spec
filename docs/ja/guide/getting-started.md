# はじめに

**ドキュメントサイト：** [jackyko1991.github.io/kaizen-spec](https://jackyko1991.github.io/kaizen-spec/)
**GitHub：** [github.com/jackyko1991/kaizen-spec](https://github.com/jackyko1991/kaizen-spec)

このガイドでは、kaizen-spec のインストールと初回の `/kaizen-spec` セッションの実行方法を説明します。

---

## 前提条件

- [Claude Code](https://claude.ai/code) のインストール（CLI または VS Code 拡張機能）
- Git
- Node.js 18+（VitePress ドキュメントサイトをローカルで実行する場合のみ必要）

---

## インストール

### オプション A — curl ワンライナー（推奨）

最も手軽なインストール方法です。ターミナルで次を実行してください：

```bash
curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/install.sh | bash
```

これにより `install.sh` がダウンロード・実行され、`kaizen-spec.md` が自動的に `~/.claude/commands/` にインストールされます。

インターネットからスクリプトをパイプで実行したくない場合は、スキルファイルを直接ダウンロードすることもできます：

```bash
curl -fsSL https://raw.githubusercontent.com/jackyko1991/kaizen-spec/master/.claude/commands/kaizen-spec.md \
  > ~/.claude/commands/kaizen-spec.md
```

アップグレードするには、同じコマンドを再実行するだけです。Claude Code は `~/.claude/commands/` にある `.md` ファイルを自動的にスラッシュコマンドとして認識します。

---

## インストールの確認

Claude Code で任意のプロジェクトを開き、次を入力します：

```
/kaizen-spec
```

正しくインストールされていれば、スキルがフェーズ 1 を開始し「この機能が解決するコアな問題、または追加するものは何ですか？」と尋ねます。

コマンドが見つからない場合は、`~/.claude/commands/kaizen-spec.md` が存在するか確認してください：

```bash
ls -la ~/.claude/commands/kaizen-spec.md
```

---

## はじめての実行

1. Claude Code でプロジェクトを開く — 言語・種類は問いません。
2. `/kaizen-spec` と入力し、作りたいものを説明する（空欄のまま質問に答えても構いません）。
3. フェーズ 1 のアラインメント質問に答える。時間をかけて — これが最も重要なフェーズです。
4. フェーズ 2 でテストフレームワークを確認する。
5. フェーズ 3 を観察する：`.kaizen/board.html` をブラウザで開くと、エージェントの進捗をライブで確認できます。
6. フェーズ 4 と 5 は自動的に完了します。

仕様から動作・テスト済み・ドキュメント完備のコードまで、サイクル全体は機能の複雑さによって通常 15〜45 分かかります。

---

## ドキュメントサイトをローカルで実行する

```bash
cd ~/.claude/skills/kaizen-spec
npm install
npm run docs:dev
```

その後ブラウザで `http://localhost:5173` を開いてください。

---

## セルフホスティングテスト（上級者向け）

インストールの究極のテスト：kaizen-spec を使って kaizen-spec 自身を開発する。

```bash
cd ~/.claude/skills/kaizen-spec
# Claude Code で開いてから実行:
/kaizen-spec "add a kaizen-log tail command that shows the last N entries"
```

5 つのフェーズがすべて完了し、ボードのすべてのカードが「完了」列に表示されていれば、インストールは正常に動作しています。完全なセルフホスティング受け入れ基準については [checklist.md](https://github.com/jackyko/kaizen-spec/blob/main/features/kaizen-spec/checklist.md) のフェーズ 6 を参照してください。

---

## アップデート

オプション B（シンボリックリンク）でインストールした場合：

```bash
cd ~/.claude/skills/kaizen-spec
git pull
```

シンボリックリンクにより、Claude Code は更新されたスキルを即座に認識します — 再リンクは不要です。

---

## アンインストール

```bash
rm ~/.claude/commands/kaizen-spec.md
# 任意:
rm -rf ~/.claude/skills/kaizen-spec
```

---

## トラブルシューティング

**Claude Code で `/kaizen-spec` が見つからない**

コマンドディレクトリを確認してください：
```bash
ls ~/.claude/commands/
```
`kaizen-spec.md` ファイルが存在する必要があります。シンボリックリンクを使用している場合は、正しく解決されるか確認してください：
```bash
readlink -f ~/.claude/commands/kaizen-spec.md
```

**スキルは起動するが `AskUserQuestion` を使用しない**

これは Claude Code が対話型ツール使用をサポートしないコンテキスト（非対話型パイプなど）で実行されていることを意味します。スクリプトからではなく、Claude Code の対話セッションから実行してください。

**`.kaizen/board.html` が自動リロードされない**

ボードは 5 秒ごとに `location.reload()` をポーリングします。ファイルをブラウザで直接開いていること（file:// またはローカル HTTP サーバー経由）を確認してください。JavaScript をブロックするプレビューパネルでは動作しません。

**実装前にテストが通過する（フェーズ 2 の警告）**

スキルはここで意図的に停止します。これは次のいずれかを意味します：
- テストが間違ったものをテストしている（空洞なテスト）
- 機能が既に部分的に存在している

テスト出力を読み、テストが実際に失敗するよう修正してから、フェーズ 2 を再実行してください。
