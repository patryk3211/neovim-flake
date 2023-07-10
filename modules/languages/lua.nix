{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.neovim.language.lua;
in {
  options.neovim.language.lua = {
    enable = mkEnableOption "Enable Lua language configuration";
  };

  config = mkIf cfg.enable {
    neovim.lsp.servers = [{
      name = "lua_ls";
      executable = "lua-language-server";
      args = {
        runtime = "LuaJIT";
        diagnostics = {
          globals = [ "vim" ];
        };
        workspace = {
          library = { __lua__ = "vim.api.nvim_get_runtime_file(\"\", true)"; };
        };
        telemetry = {
          enable = false;
        };
      };
      package = pkgs.lua-language-server;
    }];

    neovim.treesitter.grammars = [ pkgs.tree-sitter-grammars.tree-sitter-lua ];
  };
}
