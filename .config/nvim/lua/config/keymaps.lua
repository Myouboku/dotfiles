-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del({ "n", "i", "v" }, "<A-j>")
vim.keymap.del({ "n", "i", "v" }, "<A-k>")
vim.keymap.set({ "n", "i", "v" }, "<A-j>", "<cmd>cnext<cr>")
vim.keymap.set({ "n", "i", "v" }, "<A-k>", "<cmd>cprev<cr>")
