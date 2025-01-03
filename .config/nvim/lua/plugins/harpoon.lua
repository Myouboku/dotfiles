return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    harpoon:setup {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        key = function()
          return vim.loop.cwd()
        end,
      },
    }

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { desc = 'Harpoon [A]dd' })
    vim.keymap.set('n', '<leader>hl', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Harpoon [L]ist' })

    vim.keymap.set('n', '<A-&>', function()
      harpoon:list():select(1)
    end)
    vim.keymap.set('n', '<A-é>', function()
      harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<A-">', function()
      harpoon:list():select(3)
    end)
    vim.keymap.set('n', "<A-'>", function()
      harpoon:list():select(4)
    end)
    vim.keymap.set('n', '<A-(>', function()
      harpoon:list():select(5)
    end)
  end,
}
