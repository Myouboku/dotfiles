return {
  "nvim-neotest/neotest",
  dependencies = { "adrigzr/neotest-mocha" },
  opts = {
    adapters = {
      require("neotest-mocha"),
    },
  },
}
