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
  config = function(_, opts)
    local dap = require("dap")
    local dapui = require("dapui")

    opts.layouts = {
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
    }

    dapui.setup(opts)

    dap.listeners.before.attach.dapui_config = dapui.open
    dap.listeners.before.launch.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close
  end,
}
