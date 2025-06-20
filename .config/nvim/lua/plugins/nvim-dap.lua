return {
  "mfussenegger/nvim-dap",
  keys = {
    {
      "<leader>dO",
      function()
        require("dap").step_out()
      end,
      desc = "Step Out",
    },
    {
      "<leader>do",
      function()
        require("dap").step_over()
      end,
      desc = "Step Over",
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
