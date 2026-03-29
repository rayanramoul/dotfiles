-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps hereby
-- vim.keymap.set("n", "<leader>pv", ":Neotree toggle<CR>")
vim.keymap.set("n", "J", "mzJ`z")

-- Allow half page jumpings to keep the cursor in the middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Allows search terms to keep cursor in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
-- Allow to copy paste and dont have the buffer reinitialized after pasting
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
-- interactions with the system copy buffers
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>q", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Add visual keymap so that when in visual mode, selected text get searched globally
vim.keymap.set("v", "*", ":<C-u>call VisualSelection('f')<CR>", { noremap = true, silent = true })
vim.keymap.set("n", ";", ":", { noremap = true, silent = true })

-- Tmux navigation (also configured in plugins/tmux.lua for lazy-loading)
vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>")
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>")
vim.keymap.set("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>")

vim.keymap.set(
  "n",
  "<C-f>",
  "<cmd>silent !tmux neww tmux-sessionizer<CR>",
  { desc = "Switch to or create tmux session Tmux-Sessionizer" }
)
vim.keymap.set("n", "<C-n>", function()
  os.execute("tmux switch-client -t Notes || tmux new-session -s Notes")
end, { desc = "Switch to or create tmux session Notes" })

vim.keymap.set("x", "p", '"_dP', { desc = "Paste without overwriting yank register" })

-- open current buffer in cursor
vim.keymap.set("n", "<leader>cu", "<cmd>silent !cursor %<CR>", { desc = "Open current buffer in cursor" })

-- go from terminal mode to normal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

vim.opt.clipboard = "unnamed"
