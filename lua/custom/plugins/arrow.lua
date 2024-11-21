return {
  'otavioschwanck/arrow.nvim',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' },
    -- or if using `mini.icons`
    -- { "echasnovski/mini.icons" },
  },
  opts = {
    show_icons = true,
    leader_key = ';', -- Recommended to be a single key
    buffer_leader_key = 'm', -- Per Buffer Mappings
    mappings = {
      edit = 'e',
      delete_mode = 'D',
      clear_all_items = 'C',
      toggle = 't', -- used as save if separate_save_and_remove is true
      open_vertical = 's',
      open_horizontal = 'S',
      quit = 'q',
      remove = 'd', -- only used if separate_save_and_remove is true
      next_item = 'n',
      prev_item = 'p',
    },
  },
}
