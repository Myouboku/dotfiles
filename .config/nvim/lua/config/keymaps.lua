-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local set = vim.keymap.set

set("i", "jk", "<Esc>")
set("n", "<A-g>", function()
    LazyVim.lazygit({ cwd = LazyVim.root.git() })
end)
set("n", "<A-G>", function()
    LazyVim.lazygit()
end)
