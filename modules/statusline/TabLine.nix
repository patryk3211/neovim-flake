{ config, ... }:

{
config.neovim.statusline.components.TabLine = ''
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
  end,
  hl = function(self)
    if self.is_active then
      return "TabLineSel"
    else
      return "TabLine"
    end
  end,
  on_click = {
    callback = function(_, minwid, _, button)
      if button == 'm' then
        vim.schedule(function()
          local curBufId = vim.api.nvim_get_current_buf()
          if curBufId == minwid then
            local buffers = vim.api.nvim_list_bufs()
            local prev = 0
            for _, buffer in ipairs(buffers) do
              if buffer == minwid then
                break
              end
              if vim.api.nvim_buf_get_option(buffer, "buflisted") then
                prev = buffer
              end
            end
            if prev == 0 and #buffers > 1 then
              for _, buffer in ipairs(buffers) do
                if buffer ~= minwid then
                  if vim.api.nvim_buf_get_option(buffer, "buflisted") then
                    prev = buffer
                    break
                  end
                end
              end
            end
            if prev ~= 0 then
              vim.api.nvim_win_set_buf(0, prev)
            end
          end
          local status, err = pcall(function() vim.api.nvim_buf_delete(minwid, { force = false }) end)
          if not status then
            print(err)
          end
        end)
      else
        vim.api.nvim_win_set_buf(0, minwid)
      end
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = "heirline_tabline_buffer_callback",
  },

  { -- Buffer number
    provider = function(self)
      return " "..tostring(self.bufnr)..": ";
    end,
  },
  { -- Icon
    init = function(self)
      local extension = vim.fn.fnamemodify(self.filename, ":e")
      self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(self.filename, extension, { default = true })
    end,
    provider = function(self)
      return self.icon.." "
    end,
    hl = function(self)
      return {
        fg = self.icon_color
      }
    end,
  },
  { -- File name
    provider = function(self)
      local name = self.filename
      if name == "" then
        name = "[No Name]"
      else
        name = vim.fn.fnamemodify(name, ":t")
      end
      return name.." "
    end,
    hl = function(self)
      return { bold = self.is_active or self.is_visible }
    end,
  },
'';}
