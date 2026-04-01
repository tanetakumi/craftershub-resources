# CraftersHub Resources

このリポジトリは、CraftersHub まわりの導入用スクリプトをまとめるための置き場です。

## ファイル構成

```text
.
├── install-docker.sh            # Ubuntu に Docker CE を導入するスクリプト
└── README.md
```

## 使い方

### Docker を入れる

```bash
sudo ./install-docker.sh
```

必要なら対象ユーザーを明示できます。

```bash
sudo ./install-docker.sh --user yourname
```

## 補足

- `install-docker.sh` は Ubuntu 前提です。
- Docker を入れたあと、`docker` グループへの反映を使うには一度ログアウトして入り直すか、`newgrp docker` を実行します。
