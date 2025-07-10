return {
  "mfussenegger/nvim-dap",
  keys = {
    {
      "<F7>",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle Breakpoint",
    },
    {
      "<F19>",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Breakpoint Condition",
    },
    {
      "<F8>",
      function()
        require("dap").continue()
      end,
      desc = "Run/Continue",
    },
    {
      "<F20>",
      function()
        require("dap").run_last()
      end,
      desc = "Run Last",
    },
    {
      "<F9>",
      function()
        require("dap").step_over()
      end,
      desc = "Step Over",
    },
    {
      "<F10>",
      function()
        require("dap").step_into()
      end,
      desc = "Step Into",
    },
    {
      "<F22>",
      function()
        require("dap").step_out()
      end,
      desc = "Step Out",
    },
  },
  opts = function()
    local dap = require("dap")
    local js_based_languages = { "typescript", "javascript", "typescriptreact" }

    for _, language in ipairs(js_based_languages) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "node",
          program = "src/index.js",
          cwd = "${workspaceFolder}/srv",
          env = {
            NODE_ENV = "development",
          },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "nodemon",
          runtimeExecutable = "nodemon",
          program = "src/index.js",
          cwd = "${workspaceFolder}/srv",
          env = {
            NODE_ENV = "development",
          },
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          env = {
            NODE_ENV = "development",
          },
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
    end
  end,
}
