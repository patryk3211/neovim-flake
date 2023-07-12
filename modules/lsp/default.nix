{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.neovim.lsp;
in {
  imports = [
  ];

  options.neovim.lsp = {
    enable = mkEnableOption "Enable NeoVim language server protocol";

    capabilities = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        A list of capabilities passed to LSP servers (has to be valid Lua code which returns a table)
      '';
    };

    keymap = mkOption {
      type = nvim.types.keybindsModes;
      description = ''
        Configures keybinds mapped to a buffer after LSP successfully attaches to it
      '';
      default = {};
    };

    servers = mkOption {
      type = types.listOf nvim.types.lspServer;
      description = ''
        List of configured language servers
      '';
      default = [];
    };

    lspBinaries = mkOption {
      type = types.listOf types.package;
      description = ''
        List of packages required by language servers.
      '';
      readOnly = true;
    };
  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [ "nvim-lspconfig" ]
    ++ (if config.neovim.completion.enable then [ "cmp-nvim-lsp" ] else []);

    neovim.keymap = mkDefault {
      normal = {
        "<Space>f" = {
          bind = "vim.diagnostic.open_float";
          lua = true;
          description = "Open diagnostic float";
        };
      };
    };

    neovim.lsp.keymap = mkDefault {
      normal = {
        "gD" = {
          bind = "vim.lsp.buf.declaration";
          lua = true;
          noremap = true;
          description = "Go to symbol declaration";
        };
        "gd" = {
          bind = "vim.lsp.buf.definition";
          lua = true;
          noremap = true;
          description = "Go to symbol definition";
        };
        "gi" = {
          bind = "vim.lsp.buf.implementation";
          lua = true;
          noremap = true;
          description = "Go to symbol implementation";
        };
        "gR" = {
          bind = "vim.lsp.buf.references";
          lua = true;
          noremap = true;
          description = "Go to symbol references";
        };
        "<Space>F" = {
          bind = nvim.lua.wrapFunction "vim.lsp.buf.format { async = true }";
          lua = true;
          noremap = true;
          description = "Perform code formatting";
        };
        "<Space>ca" = {
          bind = "vim.lsp.buf.code_action";
          lua = true;
          noremap = true;
          description = "Show code actions";
        };
        "<Space>rn" = {
          bind = "vim.lsp.buf.rename";
          lua = true;
          noremap = true;
          description = "Rename symbol/function/etc.";
        };
        "<C-k>" = {
          bind = "vim.lsp.buf.signature_help";
          lua = true;
          noremap = true;
          description = "Display signature help";
        };
        "<Space>H" = {
          bind = "vim.lsp.buf.hover";
          lua = true;
          noremap = true;
          description = "Display hover information";
        };
      };
    };

    neovim.initScriptLua = let
      capabilities = concatStringsSep "\n" (map (cap: "mergeTables(capabilities, ${cap})") cfg.capabilities);
      initServer = server: "lspconfig.${server.name}.setup ${nvim.lua.toString ({ cmd = ["${server.package}/bin/${server.executable}"]; capabilities = { __lua__ = "capabilities"; }; } // server.args)}";
    in ''
      local lspconfig = require 'lspconfig'
      -- Build capabilities table
      local capabilities = {}
      local function mergeTables(result, addition)
        for k, v in pairs(addition) do
          if type(v) == "table" and type(result[k] or false) == "table" then
            mergeTables(result[k], v)
          else
            result[k] = v
          end
        end
      end
      ${capabilities}
      -- Initialize LSP servers
      ${concatStringsSep "\n" (map initServer cfg.servers)}
      
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          ${nvim.keybind.toLua cfg.keymap { buffer = "ev.buf"; }}
        end,
      })
    '';

    neovim.lsp.lspBinaries = map (server: server.package) cfg.servers;
  };
}
