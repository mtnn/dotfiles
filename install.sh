#!/usr/bin/env bash
# dotfiles installer
# 実体は ~/dotfiles 配下に置き、各設定の本来の場所へシンボリックリンクを張る。
# 既存の実体があれば *.bak-YYYYmmddHHMMSS へ退避してからリンクする。
set -euo pipefail

# このスクリプトのある場所を dotfiles ルートとして解決（cloneした場所に依存しない）
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d%H%M%S)"

link() {
  # link <実体パス> <リンクを張る場所>
  local src="$1" dest="$2"

  # 既に正しいリンクなら何もしない
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "  ok    $dest"
    return
  fi

  # 既存の実体（ファイル/ディレクトリ/別リンク）があれば退避
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "  backup $dest -> ${dest}.bak-${STAMP}"
    mv "$dest" "${dest}.bak-${STAMP}"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  echo "  link  $dest -> $src"
}

echo "dotfiles root: $DOTFILES"
echo

echo "[ghostty]  (cmux もこの設定を読みます)"
mkdir -p "$CONFIG/ghostty"
link "$DOTFILES/ghostty/config" "$CONFIG/ghostty/config"
echo

echo "[cmux]  (cmux 固有設定。ターミナル描画は ghostty 側)"
mkdir -p "$CONFIG/cmux"
link "$DOTFILES/cmux/cmux.json" "$CONFIG/cmux/cmux.json"
echo

echo "[wezterm]"
link "$DOTFILES/wezterm" "$CONFIG/wezterm"
echo

echo "[nvim]"
link "$DOTFILES/nvim" "$CONFIG/nvim"
echo

echo "[via]"
echo "  skip  VIA のキーマップ(JSON)は自動リンク対象外です。"
echo "        VIA アプリを開き、via/tide49/*.json を手動でインポートしてください。"
echo

echo "done. cmux/Ghostty を使う場合は 'cmux reload-config' または Cmd+Shift+, で反映できます。"
