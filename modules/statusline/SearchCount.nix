{ config, ... }:

{
config.neovim.statusline.components.SearchCount = ''
condition = function()
  return vim.v.hlsearch ~= 0
end,
hl = {
  bg = "surface0",
},
{
  provider = "",
  hl = {
    bg = "mantle",
    fg = "surface0",
  },
},
{
  init = function(self)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      self.search = search
    end
  end,
  provider = function(self)
    return string.format("  %d/%d ", self.search.current, math.min(self.search.total, self.search.maxcount))
  end,
},
{
  provider = "",
  hl = {
    bg = "mantle",
    fg = "surface0",
  },
},
'';
}
