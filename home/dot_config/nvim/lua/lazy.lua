return {
  -- Colorscheme
  {
    "rose-pine/neovim",
    lazy = false,
    priority = 1000,
    config = function()
      require("rose-pine").setup({
        styles = {
          transparency = true,
          italic = true,
          bold = true,
        },
      })
    end,
  },

  -- Mini.nvim
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini").setup({
        mappings = {
          mini = true,
        },
      })
    end,
  },

  -- Leap
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").setup()
    end,
  },

  -- Refactoring
  {
    "ThePrimeagen/refactoring.nvim",
    config = function()
      require("refactoring").setup()
    end,
  },

  -- Schema Store
  {
    "b0o/SchemaStore.nvim",
    config = function()
      require("schemastore").setup()
    end,
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Neotree
  {
    "nvim-neo-tree/neo-tree.nvim",
    config = function()
      require("neo-tree").setup()
    end,
  },

  -- Obsidian
  {
    "epwalsh/obsidian.nvim",
    config = function()
      require("obsidian").setup()
    end,
  },

  -- UV
  {
    "astral-sh/uv.nvim",
    config = function()
      require("uv").setup()
    end,
  },

  -- Tmux
  {
    "christoomey/vim-tmux-navigator",
    config = function()
      require("tmux").setup()
    end,
  },

  -- Lazygit
  {
    "kdheepak/lazygit.nvim",
    config = function()
      require("lazygit").setup()
    end,
  },

  -- Lazydocker
  {
    "lazytanuki/nvim-dap-projects",
    config = function()
      require("lazydocker").setup()
    end,
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      },
      settings = {
        save_on_toggle = true,
      },
    },
    keys = function()
      local keys = {
        {
          "<C-a>",
          function()
            require("harpoon"):list():add()
          end,
          desc = "Harpoon File",
        },
        {
          "<C-e>",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Harpoon Quick Menu",
        },
      }

      for i = 1, 5 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i)
          end,
          desc = "Harpoon to File " .. i,
        })
      end
      return keys
    end,
  },

  -- Blink
  {
    "folke/blink.nvim",
    config = function()
      require("blink").setup()
    end,
  },
  {
	"rose-pine/neovim",
	name = "rose-pine",
	config = function()
		vim.cmd("colorscheme rose-pine")
	end
  },
    -- Supermaven
    {
        "supermaven-inc/supermaven-nvim",
        config = function()
            require("supermaven-nvim").setup({
                keymaps = {
                  accept_suggestion = "<Tab>",
                  clear_suggestion = "<C-]>",
                  accept_word = "<C-j>",
                },
                ignore_filetypes = { cpp = true }, -- or { "cpp", }
                color = {
                  suggestion_color = "#ffffff",
                  cterm = 244,
                },
                log_level = "info", -- set to "off" to disable logging completely
                disable_inline_completion = false, -- disables inline completion for use with cmp
                disable_keymaps = false, -- disables built in keymaps for more manual control
                condition = function()
                  return false
                end -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
              })
        end,
    },

    -- Zen Mode (replacement for snacks zen)
    {
      "folke/zen-mode.nvim",
      opts = {
        window = {
          backdrop = 0.95,
          width = 120,
          height = 1,
          options = {
            signcolumn = "no",
            number = false,
            relativenumber = false,
            cursorline = false,
            cursorcolumn = false,
            foldcolumn = "0",
            list = false,
          },
        },
        plugins = {
          options = {
            enabled = true,
            ruler = false,
            showcmd = false,
          },
          twilight = { enabled = true },
          gitsigns = { enabled = false },
          tmux = { enabled = false },
        },
      },
      keys = {
        { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
      },
    },

    -- Twilight (companion to zen-mode)
    {
      "folke/twilight.nvim",
      opts = {},
    },

    -- Nvim-notify (replacement for snacks notifier)
    {
      "rcarriga/nvim-notify",
      opts = {
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
      },
      init = function()
        vim.notify = require("notify")
      end,
      keys = {
        { "<leader>n", function() require("notify").dismiss({ silent = true, pending = true }) end, desc = "Dismiss notifications" },
      },
    },

    -- Indent-blankline (replacement for snacks indent)
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      opts = {},
    },

    -- Dashboard (replacement for snacks dashboard)
    {
      "goolord/alpha-nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("alpha").setup(require("alpha.themes.startify").config)
      end,
    },
}
