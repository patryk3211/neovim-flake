{ config, ... }:

{
config.neovim.statusline.components.GitStatus = ''
condition = heirconditions.is_git_repo,
init = function(self)
  self.status = vim.b.gitsigns_status_dict
  self.added = self.status.added or 0
  self.removed = self.status.removed or 0
  self.changed = self.status.changed or 0
  -- self.has_changes = self.status.added ~= 0 or self.status.removed ~= 0 or self.status.changed ~= 0
end,
hl = {
  bg = "mantle",
  fg = "sapphire",
},
update = { "BufWrite" },

{ -- Added
  provider = function(self)
    return self.added > 0 and " +"..self.added
  end,
  hl = { fg = "green" },
},
{ -- Removed
  provider = function(self)
    return self.removed > 0 and " -"..self.removed
  end,
  hl = { fg = "red" },
},
{ -- Changed
  provider = function(self)
    return self.changed > 0 and " ~"..self.changed
  end,
  hl = { fg = "yellow" },
},
{ -- Branch
  provider = function(self)
    return "  "..self.status.head.." "
  end,
},
'';}
