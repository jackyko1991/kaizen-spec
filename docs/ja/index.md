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
