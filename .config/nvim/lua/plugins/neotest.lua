return {
  "nvim-neotest/neotest",
  dependencies = {
    { "adrigzr/neotest-mocha", commit = "342664d54d2177cd0b21742ddf8c447ff278df46" },
  },
  opts = {
    adapters = {
      ["neotest-mocha"] = {
        command = "npm run test:api --",
        command_args = function(context)
          -- The context contains:
          --   results_path: The file that json results are written to
          --   test_name: The exact name of the test; is empty for `file` and `dir` position tests.
          --   test_name_pattern: The generated pattern for the test
          --   path: The path to the test file
          --
          -- It should return a string array of arguments
          --
          -- Not specifying 'command_args' will use the defaults below

          -- Clean test_name_pattern: remove backticks that break grep regex
          -- local clean_pattern = context.test_name_pattern:gsub("`", "")

          return {
            "--full-trace",
            "--reporter=json",
            "--reporter-options=output=" .. context.results_path,
            -- "--grep=" .. clean_pattern,
            -- "--grep=" .. context.test_name_pattern,
            "--grep=" .. context.test_name,
            context.path,
          }
        end,
        env = { NODE_ENV = "test", CI = true },
        cwd = function(path)
          return vim.fn.getcwd()
        end,
      },
    },
  },
}
