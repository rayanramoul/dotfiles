return {
  "mgierada/lazydocker.nvim",
  dependencies = { "akinsho/toggleterm.nvim" },
  config = function()
    require("lazydocker").setup({})
  end,
  event = "BufRead", -- or any other event you might want to use.
  keys = {
    { "<leader>dd", "<cmd>Lazydocker<cr>", desc = "LazyDocker" },
  },
}
