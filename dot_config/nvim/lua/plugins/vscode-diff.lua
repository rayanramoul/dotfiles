return {
  "esmuellert/vscode-diff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "CodeDiff",
  keys = {
    { "<leader>gD", "<cmd>CodeDiff<cr>", desc = "CodeDiff (VSCode-style diff)" },
  },
  config = function()
    require("vscode-diff").setup({
      diff = {
        disable_inlay_hints = true,
      },
    })
  end,
}


