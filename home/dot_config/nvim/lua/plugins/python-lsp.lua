-- Override pyright/basedpyright root_dir for uv workspaces.
--
-- Problem: Neovim resolves the LSP root by finding the nearest ancestor with
-- a root_markers file. In a uv workspace, each sub-package has its own
-- pyproject.toml, so pyright starts scoped to that package only — "find
-- references" won't cross package boundaries even though the packages share
-- a virtual environment.
--
-- Fix: prefer uv.lock as the root marker (only exists at the workspace root),
-- then fall back to pyrightconfig.json (also only at the workspace root),
-- then fall back to standard project markers.
--
-- Neovim 0.12 root_dir signature: fun(bufnr, on_dir) — on_dir is an async
-- callback that MUST be called, or the LSP is silently never activated.
-- Uses vim.fs.root(bufnr, markers) which is the native 0.10+ API and
-- correctly searches ancestor directories from the buffer's file location.
local function uv_workspace_root(bufnr, on_dir)
  local root = vim.fs.root(bufnr, "uv.lock")
    or vim.fs.root(bufnr, "pyrightconfig.json")
    or vim.fs.root(bufnr, { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt" })
  on_dir(root)
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = { root_dir = uv_workspace_root },
        basedpyright = { root_dir = uv_workspace_root },
      },
    },
  },
}
