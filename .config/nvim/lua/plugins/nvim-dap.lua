return {
  "mfussenegger/nvim-dap",
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
          address = "localhost",
          port = 3000,
          cwd = "${workspaceFolder}/srv",
          env = {
            NODE_ENV = "development",
          },
          console = "integratedTerminal",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "nodemon",
          runtimeExecutable = "nodemon",
          program = "src/index.js",
          address = "localhost",
          port = 3000,
          cwd = "${workspaceFolder}/srv",
          restart = true,
          env = {
            NODE_ENV = "development",
          },
          console = "integratedTerminal",
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
          console = "integratedTerminal",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        },
      }
    end
  end,
}
