-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Autocommandes ici pour s'exécuter au lancement, sinon VeryLazy empêchera leur exécution
vim.api.nvim_create_autocmd("VimEnter", {
  command = ":silent !kitten @ set-spacing padding=0",
})

vim.api.nvim_create_autocmd("VimLeave", {
  command = ":silent !kitten @ set-spacing padding=default",
})
