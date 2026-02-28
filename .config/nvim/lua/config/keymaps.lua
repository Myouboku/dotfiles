-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.del({ "n", "i", "v" }, "<A-j>")
vim.keymap.del({ "n", "i", "v" }, "<A-k>")
vim.keymap.set({ "n", "i", "v" }, "<A-j>", function()
  if require("trouble").is_open() then
    ---@diagnostic disable-next-line: missing-parameter, missing-fields
    require("trouble").next({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cnext)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end)
vim.keymap.set({ "n", "i", "v" }, "<A-k>", function()
  if require("trouble").is_open() then
    ---@diagnostic disable-next-line: missing-parameter, missing-fields
    require("trouble").prev({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cprev)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end)
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
