{ config, ... }:

{
config.neovim.statusline.components.Diagnostics = ''
static = {
  error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1];
  warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1];
  info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1];
  hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1];
},
init = function(self)
  self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) or 0
  self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) or 0
  self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }) or 0
  self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }) or 0
end,
update = { "DiagnosticChanged", "BufEnter" },
hl = {
  bg = "mantle",
},

{ provider = " " },
{ -- Errors
  provider = function(self)
    return self.errors > 0 and self.error_icon.text..self.errors.." "
  end,
  hl = function(self)
    return { fg = heirutils.get_highlight(self.error_icon.texthl).fg }
  end,
},
{ -- Warnings
  provider = function(self)
    return self.warnings > 0 and self.warn_icon.text..self.warnings.." "
  end,
  hl = function(self)
    return { fg = heirutils.get_highlight(self.warn_icon.texthl).fg }
  end,
},
{ -- Info
  provider = function(self)
    return self.info > 0 and self.info_icon.text..self.info.." "
  end,
  hl = function(self)
    return { fg = heirutils.get_highlight(self.info_icon.texthl).fg }
  end,
},
{ -- Hints
  provider = function(self)
    return self.hints > 0 and self.hint_icon.text..self.hints.." "
  end,
  hl = function(self)
    return { fg = heirutils.get_highlight(self.hint_icon.texthl).fg }
  end,
},
'';}
