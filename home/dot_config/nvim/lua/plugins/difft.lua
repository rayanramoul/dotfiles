-- luacheck: globals Difft
return {
  'ahkohd/difft.nvim',
  keys = {
    {
      '<leader>d',
      function()
        if Difft.is_visible() then
          Difft.hide()
        else
          Difft.diff()
        end
      end,
      desc = 'Toggle Difft',
    },
  },
  config = function()
    require('difft').setup({
      -- Ensure ANSI colors by forcing difft to always colorize output
      -- You must have difftastic installed and available on PATH
      command = "GIT_EXTERNAL_DIFF='difft --color=always' git diff",
      -- layout = nil, -- use current buffer by default; options: 'float', 'ivy_taller'
    })
  end,
}


