return {
  "rcarriga/nvim-dap-ui",
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
        position = "left",
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

    dap.listeners.after.event_initialized["dapui_config"] = nil
    dap.listeners.before.event_terminated["dapui_config"] = nil
    dap.listeners.before.event_exited["dapui_config"] = nil
  end,
}
