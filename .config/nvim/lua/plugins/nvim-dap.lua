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
          restart = true,
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
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-chrome",
          request = "launch",
          name = 'Start Chrome with "localhost"',
          url = "http://localhost:3000",
          webRoot = "${workspaceFolder}",
          userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
        },
      }
    end
  end,
}
