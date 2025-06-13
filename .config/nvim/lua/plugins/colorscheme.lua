return {
  {
    "scottmckendry/cyberdream.nvim",
    opts = {
      variant = "auto",
      transparent = true,
      italic_comments = true,
      borderless_pickers = true,
    },
    keys = {
      { "<leader>ut", "<cmd>CyberdreamToggleMode<CR>", desc = "Toggle Light/Dark theme" },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cyberdream",
    },
  },
}
