{ config, ... }:

{
config.neovim.statusline.components.FileStatus = ''
hl = {
  bg = "base",
  fg = "overlay2",
},
{ -- File type icon
  init = function(self)
    local filename = vim.api.nvim_buf_get_name(0)
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return " "..self.icon
  end,
  hl = function(self)
    return {
      fg = self.icon_color
    }
  end,
},
{ -- File name
  provider = " %t ",
},
{ -- Separator
  hl = {
    bg = "mantle",
    fg = "base",
  },
  provider = "",
},
'';}
