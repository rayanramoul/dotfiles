-- refactoring.nvim — extract / inline / debug-print helpers (ThePrimeagen).
-- Recent versions `require "async"` from a separate plugin; without it
-- LazyVim errors on startup with "module 'async' not found".
return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = { "lewis6991/async.nvim" },
    lazy = false,
  },
}
