return {
  "Cannon07/claude-preview.nvim",
  config = function()
    require("claude-preview").setup({
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
