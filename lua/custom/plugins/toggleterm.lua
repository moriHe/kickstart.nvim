return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      -- You can add configuration options here
      open_mapping = [[<leader>t]], -- Example: Set Ctrl + t as the toggle shortcut
    }
  end,
}
