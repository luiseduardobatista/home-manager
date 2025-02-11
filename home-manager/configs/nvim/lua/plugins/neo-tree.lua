return {
  "nvim-neo-tree/neo-tree.nvim",
  config = function()
    local nvimtree = require("neo-tree")
    nvimtree.setup({
      window = {
        position = "current",
      },
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          never_show = {},
        },
      },
    })
  end,
}
