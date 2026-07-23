return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "nu",
        "bash",
        "toml",
        "dockerfile",
        "python",
      })
    end,
  },
}
