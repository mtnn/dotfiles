# dotfiles

個別に管理していた設定リポジトリを1つに統合したもの。

## 構成

| フォルダ | 内容 | リンク先 | 元リポジトリ |
| --- | --- | --- | --- |
| `ghostty/` | Ghostty/cmux 用ターミナル設定 | `~/.config/ghostty/config` | （本統合で新規追加） |
| `cmux/` | cmux 固有設定 | `~/.config/cmux/cmux.json` | （本統合で新規追加） |
| `wezterm/` | WezTerm 設定 | `~/.config/wezterm/` | `mtnn/wezterm-settings` |
| `nvim/` | Neovim (LazyVim) 設定 | `~/.config/nvim/` | `mtnn/nvim-settings` |
| `via/` | VIA キーマップ(JSON) | 自動リンクなし（VIAアプリへ手動インポート） | `mtnn/via` |

`ghostty/config` は cmux も読み込みます（cmux はターミナル描画設定を Ghostty の設定ファイルから読むため）。フォント・配色・透過などはこちらに書きます。cmux 固有の設定（ショートカット、ペイン、サイドバー、内蔵ブラウザなど）は `cmux/cmux.json` にまとめます。

`cmux.json` は JSONC（コメント可）で、書いていない項目はすべてデフォルトです。設定できる項目は `cmux docs settings` と [スキーマ](https://raw.githubusercontent.com/manaflow-ai/cmux/main/web/data/cmux.schema.json)（`$schema` 指定済みなのでエディタで補完が効く）を参照。編集後は `cmux config validate` で検証できます。

### cmux-ime-watcher（入力ソース自動切替）

cmux にフォーカスが移るたびにキーボード入力を英字 (ABC) へ切り替える常駐ウォッチャーです。`cmux/cmux-ime-watcher.swift` を `install.sh` が `swiftc` でビルドして `~/.local/bin/cmux-ime-watcher` に置き、launchd agent（`cmux/local.cmux-ime-watcher.plist.template` → `~/Library/LaunchAgents/local.cmux-ime-watcher.plist`）としてログイン時に自動起動します。追加の権限（アクセシビリティ等）は不要です。

- 状態確認: `launchctl print gui/$(id -u)/local.cmux-ime-watcher`
- 停止: `launchctl bootout gui/$(id -u)/local.cmux-ime-watcher`
- 再開/更新反映: `bash install.sh`（ビルドし直して再登録される）

cmux を使用中に新しいペインを開いたケース（フォーカスイベントが発生しない）は、`~/.zshrc` 側のシェル起動時切替（`macism com.apple.keylayout.ABC`）が補完します。cmux 内で日本語を打ちたいときは、かなキーやメニューバーからの手動切替はそのまま使えます（フォーカスが移らない限り戻されません）。

## セットアップ

```sh
git clone git@github.com:<you>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` は本来の場所へシンボリックリンクを張ります。既存の実体があれば `*.bak-<日時>` に退避してからリンクするので、上書きで消える心配はありません。

## 反映

- Ghostty / cmux: `cmux reload-config`（または cmux で `Cmd+Shift+,`）
- WezTerm: 設定の自動リロード有効（`automatically_reload_config`）
- Neovim: 再起動、または該当設定の再読み込み

## VIA について

`via/tide49/*.json` はファイルシステム上の固定パスに置く設定ではなく、VIA アプリに読み込むエクスポートファイルです。キーボード交換・OS再インストール時の復元用として保管しています。VIA アプリの Import から読み込んでください。

## メモ

- 統合時に各リポジトリの `.git` 履歴は引き継いでいません（新規リポジトリとして作成）。履歴も残したい場合は `git subtree` での取り込みに切り替えられます。
- `wezterm/wezterm-shell-integration.sh` はシェルの rc から source して使う想定です（リンクは張っていません）。
