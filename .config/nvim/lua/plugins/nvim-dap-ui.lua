return {
  "rcarriga/nvim-dap-ui",
  keys = {
    {
      "<F6>",
      function()
        require("dapui").eval()
      end,
      desc = "Eval",
      mode = { "n", "v" },
    },
  },
  opts = {
    layouts = {
      {
        elements = {
          {
            id = "scopes",
            size = 0.25,
          },
          {
            id = "breakpoints",
            size = 0.25,
          },
          {
            id = "stacks",
            size = 0.25,
          },
          {
            id = "watches",
            size = 0.25,
          },
        },
        position = "right",
        size = 40,
      },
      {
        elements = {
          {
            id = "repl",
            size = 1,
          },
          -- {
          --   id = "console",
          --   size = 0.5,
          -- },
        },
        position = "bottom",
        size = 10,
      },
    },
  },
}
