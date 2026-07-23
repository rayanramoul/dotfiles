-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps hereby

-- Quick marks and jumping
-- J: Jump to last mark (usually z after saving)
vim.keymap.set("n", "J", "mzJ`z")

-- Half page navigation keeping cursor centered
-- Move down half page and center on cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- Move up half page and center on cursor
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search navigation keeps cursor centered on matches
-- Normal and reverse search stay centered on results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Clipboard-friendly paste operations (use system clipboard, not buffer register)
-- Paste from system clipboard without triggering buffer init
vim.keymap.set("x", "<leader>p", [["_dP]])
-- Copy to system clipboard in normal and visual modes
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
-- Delete without overwriting yank register
vim.keymap.set({ "n", "v" }, "<leader>q", [["_d]])

-- Escape from insert mode (ctrl+c)
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Visual selection mode: Find and center on text occurrences
vim.keymap.set("v", "*", ":<C-u>call VisualSelection('f')<CR>", { noremap = true, silent = true })
-- Remap ; to : for quick access to command mode from mappings
vim.keymap.set("n", ";", ":", { noremap = true, silent = true })

-- Tmux pane navigation (also configured in plugins/tmux.lua for lazy-loading)
-- Tmux session manager navigation
vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>")
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>")
-- Switch between tmux layout sessions
vim.keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>")

-- Activate tmux sessionizer window
vim.keymap.set(
  "n",
  "<C-f>",
  "<cmd>silent !tmux neww tmux-sessionizer<CR>",
  { desc = "Switch to or create tmux session Tmux-Sessionizer" }
)
-- Jump to or create Notes tmux session
vim.keymap.set("n", "<C-n>", function()
  os.execute("tmux switch-client -t Notes || tmux new-session -s Notes")
end, { desc = "Switch to or create tmux session Notes" })

-- Paste in visual mode without overwriting yank register
vim.keymap.set("x", "p", '"_dP', { desc = "Paste without overwriting yank register" })

-- Open current buffer in cursor window
vim.keymap.set("n", "<leader>cu", "<cmd>silent !cursor %<CR>", { desc = "Open current buffer in cursor" })

-- Reset to normal mode from terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

vim.opt.clipboard = "unnamed"
