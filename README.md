# CraftersHub Resources

このリポジトリは CraftersHub に関わる静的アセットと認証用フォールバックページをまとめた、GitHub Pages 向けのリソース置き場です。`index.html` は簡潔なランディングページとして、CraftersHub の共有アセットや Discord に誘導し、`auth-error.html` にアクセスさせたい Cloudflare Tunnel の認証エラーを補完します。

## ファイル構成

```
.
├── assets/                 # 背景画像、アイコン、ファビコンなどのバイナリ
├── auth-error.html         # Tunnel 認証用の着地ページ
├── index.html              # ランディングページ（CraftersHub Resources）
└── README.md
```

## 公開手順

1. `main` ブランチに push する。
2. GitHub 上で Settings → Pages を開き、**Branch** を `main`、**Folder** を `/ (root)` に設定する。
3. 数分待つと `https://<user>.github.io/<repo>/` にランディングページと assets/ が公開される。
4. 必要なら Pages パネルでカスタムドメインを登録し、DNS を適切に設定する。

## 使い方

- `assets/` 内のファイルは相対パス（例: `./assets/craftershub-icon-192x192.png`）でそのまま参照できます。
- `auth-error.html` は Cloudflare Tunnel など認証が必要なトラフィックが着地する想定なので、「アクセスできる」状態を維持するだけで機能します。見た目や文言を変えたい場合はファイルを編集してください。
- Discord への誘導はトップページに載せてあるので、最新情報や追加アセット、トラブル報告があればそちらから連絡してください。
