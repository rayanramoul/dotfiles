return {
  "esmuellert/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "CodeDiff",
  keys = {
    { "<leader>gD", "<cmd>CodeDiff<cr>", desc = "CodeDiff (VSCode-style diff)" },
  },
  config = function()
    require("codediff").setup({
      diff = {
        disable_inlay_hints = true,
      },
    })
  end,
}


