{ config, ... }:

{
config.neovim.statusline.components.FileProgress = ''
update = "CursorMoved",
static = {
  bar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
},
hl = {
  bg = "surface0",
},

{ -- Separator
  hl = {
    bg = "mantle",
    fg = "surface0",
  },
  provider = "",
},
{ -- File format
  provider = function(self)
    local format = vim.bo.fileformat
    local icon = "?"
    if format == "unix" then
      icon = "  "
    elseif format == "dos" then
      icon = "  "
    elseif format == "mac" then
      icon = "  "
    end

    return icon
  end,
},
{ -- File line and column
  provider = " %l:%c ",
},
{ -- Bar
  hl = {
    bg = "base",
    fg = "lavender",
  },
  provider = function(self)
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local idx = math.floor(((line - 1) / lines) * #self.bar) + 1
    return self.bar[idx]..self.bar[idx]
  end,
},
'';}
