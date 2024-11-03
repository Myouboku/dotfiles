return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    keys = {
        { "<leader>e", ":Neotree reveal toggle=true<cr>", { desc = "Toggle Neotree" } },
    },
    opts = {
        window = {
            mappings = {
                ["l"] = "open"
            }
        }
    }
}
