return {
  "Cannon07/code-preview.nvim",
  config = function()
    require("code-preview").setup({
      diff = {
        layout = "tab",
        labels = { current = "CURRENT", proposed = "PROPOSED" },
        auto_close = true,
        equalize = true,
        full_file = true,
      },
    })
  end,
}
