return {
  "folke/todo-comments.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  event = "BufRead",
  config = function()
    require("todo-comments").setup {
      keywords = {
        GROUP = { icon = " ", color = "hint" },
        PLUGIN = { icon = " ", color = "plugin" },
      },
      highlight = { multiline = false },
      colors = { plugin = "#e89d5d" },
    }
  end,
}
