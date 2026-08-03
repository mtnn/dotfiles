-- Autocmd は VeryLazy イベントのタイミングで自動的に読み込まれる
-- LazyVim のデフォルト Autocmd 一覧: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- 追加の Autocmd はここに記述する
-- vim.api.nvim_create_autocmd を使用
--
-- デフォルトの Autocmd を無効化する場合はグループ名（lazyvim_ プレフィックス）で削除できる
-- 例: vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- WezTerm: バッファ切り替え時に OSC7 でプロジェクトルートを通知
vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
  callback = function()
    local ok, root = pcall(function()
      return LazyVim.root()
    end)
    local dir = (ok and root) and root or vim.fn.expand("%:p:h")
    if vim.fn.isdirectory(dir) == 1 then
      io.write(string.format("\027]7;file://%s%s\027\\", vim.fn.hostname(), dir))
      io.flush()
    end
  end,
})
