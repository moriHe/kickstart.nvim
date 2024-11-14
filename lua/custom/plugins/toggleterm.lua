return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      -- You can add configuration options here
      open_mapping = [[<C-t>]],
    }
  end,
}
