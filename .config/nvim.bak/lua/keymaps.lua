-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation seemless with tmux
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-right>', ':vertical resize +2<cr>', {
  desc = 'Increase split size vertically',
  silent = true,
})
vim.keymap.set('n', '<C-left>', ':vertical resize -2<cr>', {
  desc = 'Decrease split size vertically',
  silent = true,
})
vim.keymap.set('n', '<C-up>', ':resize +2<cr>', {
  desc = 'Increase split size horizontally',
  silent = true,
})
vim.keymap.set('n', '<C-down>', ':resize -2<cr>', {
  desc = 'Decrease split size horizontally',
  silent = true,
})

-- Raccourcis pour naviguer dans la quickfix list
vim.api.nvim_set_keymap('n', '<A-j>', ':cnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-k>', ':cprev<CR>', { noremap = true, silent = true })
