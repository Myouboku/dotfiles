return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "adrigzr/neotest-mocha",
  },
  opts = function(_, opts)
    opts.adapters = {
      ["neotest-mocha"] = {
        command = "zsh",
        command_args = function(ctx)
          local cmd = table.concat({
            "npm run test:api-p",
            -- "--full-trace",
            -- "--reporter=json",
            -- "--reporter-options=output=" .. ctx.results_path,
            -- "--grep=" .. ctx.test_name_pattern,
            -- ctx.path,
          }, " ")
          return { "-ic", cmd }
        end,
        env = { CI = true },
        cwd = function()
          return vim.fn.getcwd()
        end,
      },
    }
    opts.status = { virtual_text = true }
    opts.output = { open_on_run = true }
    opts.quickfix = {
      open = function()
        if LazyVim.has("trouble.nvim") then
          require("trouble").open({ mode = "quickfix", focus = false })
        else
          vim.cmd("copen")
        end
      end,
    }
    opts.diagnostic = {
      enabled = true,
      severity = 1,
    }
    opts.discovery = { enabled = false }
    return opts
  end,
}
