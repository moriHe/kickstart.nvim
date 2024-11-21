return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()
    vim.keymap.set('n', '<leader>bt', function()
      harpoon:list():add()
    end, { desc = '[T]rack' })
    vim.keymap.set('n', '<leader>bu', function()
      harpoon:list():remove()
    end, { desc = '[U]ntrack' })
    vim.keymap.set('n', '<leader>blt', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = '[T]racked' })

    vim.keymap.set('n', '<leader>b1', function()
      harpoon:list():select(1)
    end, { desc = '[1] Tracked' })
    vim.keymap.set('n', '<leader>b2', function()
      harpoon:list():select(2)
    end, { desc = '[2] Tracked' })
    vim.keymap.set('n', '<leader>b3', function()
      harpoon:list():select(3)
    end, { desc = '[3] Tracked' })
    vim.keymap.set('n', '<leader>b4', function()
      harpoon:list():select(4)
    end, { desc = '[4] Tracked' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<leader>bp', function()
      harpoon:list():prev()
    end, { desc = 'Tracked [P]revious' })
    vim.keymap.set('n', '<leader>bn', function()
      harpoon:list():next()
    end, { desc = 'Tracked [N]ext' })
  end,
}
