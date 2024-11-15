return { -- Refactoring support
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required dependency
  },
  config = function()
    require('refactoring').setup {}
    -- Define keymaps for refactoring
    vim.keymap.set('x', '<leader>ref', function()
      require('refactoring').refactor 'Extract Function'
    end, { noremap = true, silent = true, desc = 'Refactor: Extract Function' })

    vim.keymap.set('x', '<leader>reff', function()
      require('refactoring').refactor 'Extract Function To File'
    end, { noremap = true, silent = true, desc = 'Refactor: Extract Function to File' })

    vim.keymap.set('x', '<leader>rev', function()
      require('refactoring').refactor 'Extract Variable'
    end, { noremap = true, silent = true, desc = 'Refactor: Extract Variable' })
  end,
}
