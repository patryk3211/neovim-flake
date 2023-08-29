{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.neovim.language.python;
in {
  options.neovim.language.python = {
    enable = mkEnableOption "Enable Python language configuration";
  };

  config = mkIf cfg.enable {
    neovim.lsp.servers = [{
      name = "pylsp";
      executable = "pylsp";
      args = {};
      package = pkgs.python311Packages.python-lsp-server;
    }];

    neovim.treesitter.grammars = [ pkgs.tree-sitter-grammars.tree-sitter-python ];
  };
}
