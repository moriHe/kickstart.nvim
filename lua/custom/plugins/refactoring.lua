return { -- Refactoring support
  'ThePrimeagen/refactoring.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required dependency
  },
  config = function()
    require('refactoring').setup {}
    -- Define keymaps for refactoring
    vim.keymap.set({ 'x', 'v' }, '<leader>ef', function()
      require('refactoring').refactor 'Extract Function'
    end, { noremap = true, silent = true, desc = '[F]unction' })

    vim.keymap.set({ 'x', 'v' }, '<leader>eF', function()
      require('refactoring').refactor 'Extract Function To File'
    end, { noremap = true, silent = true, desc = '[F]unction to File' })

    vim.keymap.set({ 'x', 'v' }, '<leader>ev', function()
      require('refactoring').refactor 'Extract Variable'
    end, { noremap = true, silent = true, desc = '[V]ariable' })
  end,
}
