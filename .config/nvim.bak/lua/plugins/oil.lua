return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  vim.keymap.set('n', '-', '<cmd>Oil<cr>'),
}
