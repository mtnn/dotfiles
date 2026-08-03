local fallback_header = table.concat({
  "                               __                ",
  "  ___     ___    ___   __  __ /\\_\\    ___ ___    ",
  " / _ `\\  / __`\\ / __`\\/\\ \\/\\ \\\\/\\ \\  / __` __`\\  ",
  "/\\ \\/\\ \\/\\  __//\\ \\_\\ \\ \\ \\_/ |\\ \\ \\/\\ \\/\\ \\/\\ \\ ",
  "\\ \\_\\ \\_\\ \\____\\ \\____/\\ \\___/  \\ \\_\\ \\_\\ \\_\\ \\_\\",
  " \\/_/\\/_/\\/____/\\/___/  \\/__/    \\/_/\\/_/\\/_/\\/_/",
}, "\n")

local function get_header()
  local ok, ascii = pcall(require, "ascii")
  if not ok then
    return fallback_header
  end

  local header = ascii.art.text.neovim.sharp
  return type(header) == "table" and table.concat(header, "\n") or header
end

return {
  {
    "MaximilianLloyd/ascii.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },
  {
    "folke/snacks.nvim",
    dependencies = {
      "MaximilianLloyd/ascii.nvim",
    },
    opts = function(_, opts)
      opts.dashboard = opts.dashboard or {}
      opts.dashboard.preset = opts.dashboard.preset or {}
      opts.dashboard.preset.header = get_header()

      for _, item in ipairs(opts.dashboard.preset.keys or {}) do
        if item.key == "n" then
          item.action = ":ene"
        end
      end
    end,
  },
}
