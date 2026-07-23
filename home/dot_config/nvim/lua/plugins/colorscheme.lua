return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    main = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "main", -- main | moon | dawn
      dark_variant = "main", -- for dark theme
      dim_inactive_windows = false,
      extend_background_behind_toggle = true,
      styles = {
        bold = true,
        italic = true,
        transparency = true,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
