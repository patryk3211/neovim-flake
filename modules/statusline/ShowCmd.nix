{ config, ... }:

{
config.neovim.statusline.components.ShowCmd = ''
condition = function()
  local mode = vim.fn.mode(1)
  return mode:sub(1,1) == "c"
end,
provider = " %S",
'';}
