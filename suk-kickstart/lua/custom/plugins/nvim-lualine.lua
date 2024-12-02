local config = function()
  local theme = require 'lualine.themes.nord'
  --  theme.normal.c.bg = nil
  --  etc ..
  require('lualine').setup {
    options = {
      theme = theme,
      globalstatus = true,
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {},
      icons_enabled = true,
    },
    tabline = {
      lualine_a = { 'mode' },
      lualine_b = { 'buffers' },
      lualine_x = { 'enconding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    sections = {},
  }
end

return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  config = config,
}
