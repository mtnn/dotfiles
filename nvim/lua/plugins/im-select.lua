return {
  {
    "keaising/im-select.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      default_command = "/opt/homebrew/bin/macism",
      default_im_select = "com.apple.inputmethod.Kotoeri.RomajiTyping.Roman",
      set_default_events = { "InsertLeave", "CmdlineLeave" },
      set_previous_events = { "InsertEnter" },
    },
    config = function(_, opts)
      require("im_select").setup(opts)
    end,
  },
}
