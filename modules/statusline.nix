{ config, lib, ... }:
with lib;
let
  cfg = config.neovim.statusline;
in {
  options.neovim.statusline = {
    enable = mkEnableOption "Enables custom NeoVim status line";
  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [ "heirline" "gitsigns" ];

    neovim.initScriptLua = ''
      require('gitsigns').setup {
        watch_gitdir = {
          follow_files = true
        },
      }

      local heirline = require 'heirline'
      local heirutils = require 'heirline.utils'
      local heirconditions = require 'heirline.conditions'
      local StatuslineComponents = {
        ViMode = {
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
        },

	FileProgress = {
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
	},

        FileStatus = {
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
        },

        Diagnostics = {
          static = {
            error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1];
            warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1];
            info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1];
            hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1];
          },
          init = function(self)
            self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
            self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
            self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
            self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
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
        },
	GitStatus = {
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
              return " +"..(self.status.added or 0)
            end,
            hl = { fg = "green" },
          },
          { -- Removed
            provider = function(self)
              return " -"..(self.status.removed or 0)
            end,
            hl = { fg = "red" },
          },
          { -- Changed
            provider = function(self)
              return " ~"..(self.status.changed or 0)
            end,
            hl = { fg = "yellow" },
          },
          { -- Branch
            provider = function(self)
              return "  "..self.status.head
            end,
          },
	},
      }
      heirline.setup {
        statusline = {
          StatuslineComponents.ViMode, StatuslineComponents.FileStatus, StatuslineComponents.Diagnostics, { provider = "%=" },

          StatuslineComponents.GitStatus, StatuslineComponents.FileProgress,
        },
        opts = {
          colors = require('catppuccin.palettes').get_palette "frappe",
        },
      }
      vim.opt.laststatus = 3
    '';
  };
}
