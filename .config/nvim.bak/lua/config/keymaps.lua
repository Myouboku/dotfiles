vim.keymap.set("i", "jk", "<Esc>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<C-Right>", ":vertical resize +5<cr>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -5<cr>")
vim.keymap.set("n", "<C-Up>", ":horizontal resize +2<cr>")
vim.keymap.set("n", "<C-Down>", ":horizontal resize -2<cr>")

vim.keymap.set("n", "<leader>-", ":split<cr>")
vim.keymap.set("n", "<leader>|", ":vsplit<cr>")
