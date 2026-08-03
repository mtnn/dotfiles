return {
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      theme = "dragon",
      dimInactive = true,
      background = {
        dark = "dragon",
        light = "lotus",
      },
      overrides = function(colors)
        return {
          SnacksDashboardHeader = { fg = colors.palette.carpYellow, bold = true },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("kanagawa").load("dragon")
      end,
    },
  },
}
