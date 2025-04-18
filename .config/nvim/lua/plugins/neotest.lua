return {
  "nvim-neotest/neotest",
  dependencies = { "adrigzr/neotest-mocha" },
  opts = {
    -- Can be a list of adapters like what neotest expects,
    -- or a list of adapter names,
    -- or a table of adapter names, mapped to adapter configs.
    -- The adapter will then be automatically loaded with the config.
    adapters = {
      ["neotest-mocha"] = {
        command = "npm run test:api-p --",
        command_args = function(context)
          -- The context contains:
          --   results_path: The file that json results are written to
          --   test_name_pattern: The generated pattern for the test
          --   path: The path to the test file
          --
          -- It should return a string array of arguments
          --
          -- Not specifying 'command_args' will use the defaults below
          return {
            "--full-trace",
            "--reporter=json",
            "--reporter-options=output=" .. context.results_path,
            "--grep=" .. context.test_name_pattern,
            context.path,
          }
        end,
        env = { CI = true },
        cwd = function(path)
          return vim.fn.getcwd()
        end,
      },
    },
    -- Example for loading neotest-golang with a custom config
    -- adapters = {
    --   ["neotest-golang"] = {
    --     go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
    --     dap_go_enabled = true,
    --   },
    -- },
    status = { virtual_text = true },
    output = { open_on_run = true },
    quickfix = {
      open = function()
        if LazyVim.has("trouble.nvim") then
          require("trouble").open({ mode = "quickfix", focus = false })
        else
          vim.cmd("copen")
        end
      end,
    },
    diagnostic = {
      enabled = true,
      severity = 1,
    },
    discovery = { enabled = false },
  },
}
