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
}
