return {
  "stevearc/oil.nvim",
  opts = {
    view_options = {
      show_hidden = true,
    },
  },
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Oil" },
  },
}
