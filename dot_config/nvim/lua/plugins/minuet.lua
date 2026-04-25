local auto_trigger_ft = {
  "python",
  "lua",
  "rust",
  "go",
  "typescript",
  "typescriptreact",
  "javascript",
  "javascriptreact",
  "c",
  "cpp",
  "sh",
  "bash",
  "zsh",
  "nu",
  "json",
  "yaml",
  "toml",
  "markdown",
  "html",
  "css",
  "sql",
}

return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("minuet").setup({
        provider = "openai_fim_compatible",
        n_completions = 1,
        context_window = 2048,
        request_timeout = 5,
        throttle = 800,
        debounce = 400,
        provider_options = {
          openai_fim_compatible = {
            api_key = "TERM",
            name = "Ollama",
            end_point = "http://localhost:11434/v1/completions",
            model = "qwen2.5-coder:7b",
            optional = {
              max_tokens = 256,
              top_p = 0.9,
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = auto_trigger_ft,
          auto_trigger_ignore_ft = { "TelescopePrompt", "snacks_picker_input" },
          show_on_completion_menu = true,
          keymap = {
            accept = "<A-a>",
            accept_line = "<A-l>",
            prev = "<A-[>",
            next = "<A-]>",
            dismiss = "<A-e>",
          },
        },
      })

      if vim.tbl_contains(auto_trigger_ft, vim.bo.filetype) then
        vim.b.minuet_virtual_text_auto_trigger = true
      end
    end,
  },
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<A-y>"] = {
          function(cmp)
            cmp.show({ providers = { "minuet" } })
          end,
        },
      },
      sources = {
        default = { "minuet" },
        providers = {
          minuet = {
            name = "minuet",
            module = "minuet.blink",
            async = true,
            timeout_ms = 3000,
            score_offset = 50,
          },
        },
      },
      completion = {
        trigger = { prefetch_on_insert = false },
      },
    },
  },
}
