require "nvchad.mappings"

local map = vim.keymap.set

local lazyGit = function()
  require("nvchad.term").toggle {
    id = "LazyGit",
    pos = "float",
    cmd = "lazygit",
    float_opts = {
      height = 1,
      width = 1,
    },
  }
end

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<leader>pm", ":MarkdownPreviewToggle <cr>", { desc = "Toggle Markdown preview" })
map("n", "<leader>gl", lazyGit, { desc = "LazyGit" })
map({ "n", "t" }, "<A-g>", lazyGit)
