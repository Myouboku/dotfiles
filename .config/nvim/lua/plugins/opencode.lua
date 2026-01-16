return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim" },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- maybe
    }

    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode" })
    vim.keymap.set({ "n", "x" }, "<leader>oe", function()
      require("opencode").select()
    end, { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "t" }, "<leader>oo", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "go", function()
      return require("opencode").operator("@this ")
    end, { expr = true, desc = "Add range to opencode" })
    vim.keymap.set("n", "goo", function()
      return require("opencode").operator("@this ") .. "_"
    end, { expr = true, desc = "Add line to opencode" })

    require("lualine").setup({
      sections = {
        lualine_z = {
          {
            require("opencode").statusline,
          },
        },
      },
    })
  end,
}
