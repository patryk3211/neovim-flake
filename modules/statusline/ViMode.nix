{ config, ... }: {
config.neovim.statusline.components.ViMode = ''
static = {
  mode_names = {
    -- Normal modes
    n = "Norm",
    no = "N?",
    nov = "N?",
    noV = "N?",
    ["no\22"] = "N?",
    niI = "Ins",
    niR = "Rep",
    niV = "Vis",
    nt = "Term",
    ntT = "Term",
    -- Visual modes
    v = "Vis",
    vs = "VisS",
    V = "Vis-",
    Vs = "VisS",
    ["\22"] = "^Vis",
    ["\22s"] = "^Vis",
    s = "Sel",
    S = "Sel-",
    ["\19"] = "^Sel",
    -- Insert modes
    i = "Ins",
    ic = "InsC",
    ix = "InsX",
    R = "Rep",
    Rc = "RepC",
    Rx = "RepX",
    Rv = "VRep",
    Rvc = "VRC",
    Rvx = "VRX",
    -- Command modes
    c = "Cmd",
    cv = "Ex",
    r = "...",
    rm = "More",
    ["r?"] = "?",
    ["!"] = "!",
    t = "Term",
  },
  mode_colors = {
    n = "subtext0",
    v = "teal",
    V = "teal",
    ["\22"] = "teal",
    s = "yellow",
    S = "yellow",
    ["\19"] = "yellow",
    i = "green",
    R = "peach",
    c = "lavender",
    r = "lavender",
    ["!"] = "red",
    t = "blue",
  },
},
init = function(self)
  self.mode = vim.fn.mode(1)
end,
hl = function(self)
  local color = self.mode_colors[self.mode:sub(1, 1)]
  if not color then
    color = "#ffffff"
  end
  return {
    bg = color,
    fg = "crust",
    bold = true,
  }
end,
update = {
  "ModeChanged",
  --pattern = "*:*",
  --callback = vim.schedule_wrap(function()
  --  vim.cmd("redrawstatus")
  --end),
},

{ -- Icon
  provider = function(self)
    local icon = ""
    if not vim.bo.modifiable or vim.bo.readonly then
      icon = ""
    end
if vim.bo.modified then
  icon = ""
end
    if vim.bo.buftype == 'terminal' then
      icon = ""
    end
    return " "..icon
  end,
update = { "ModeChanged", "FileChangedShell" },
},
{ -- Mode name
  provider = function(self)
    local name = self.mode_names[self.mode]
    if not name then
      name = self.mode
    end
    return " %4("..name.."%) "
  end,
},
{ -- Slanted triangle
  provider = "",
  hl = function(self)
    local color = self.mode_colors[self.mode:sub(1, 1)]
    return {
      fg = color,
      bg = "base",
    }
  end
}
'';
}
