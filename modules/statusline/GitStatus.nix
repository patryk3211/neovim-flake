{ config, ... }:

{
config.neovim.statusline.components.GitStatus = ''
condition = heirconditions.is_git_repo,
init = function(self)
  self.status = vim.b.gitsigns_status_dict
  self.has_changes = self.status.added ~= 0 or self.status.removed ~= 0 or self.status.changed ~= 0
end,
hl = {
  bg = "mantle",
  fg = "sapphire",
},
update = { "BufWrite" },

{ -- Added
  provider = function(self)
    return self.status.added > 0 and " +"..(self.status.added or 0)
  end,
  hl = { fg = "green" },
},
{ -- Removed
  provider = function(self)
    return self.status.removed > 0 and " -"..(self.status.removed or 0)
  end,
  hl = { fg = "red" },
},
{ -- Changed
  provider = function(self)
    return self.status.changed > 0 and " ~"..(self.status.changed or 0)
  end,
  hl = { fg = "yellow" },
},
{ -- Branch
  provider = function(self)
    return "  "..self.status.head.." "
  end,
},
'';}
