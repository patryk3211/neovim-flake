{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.neovim.language.nix;
in {
  options.neovim.language.nix = {
    enable = mkEnableOption "Enable Nix language configuration";
  };

  config = mkIf cfg.enable {
    neovim.lsp.servers = [{
      name = "nil_ls";
      executable = "nil";
      args = {};
      package = pkgs.nil;
    }];

    neovim.treesitter.grammars = [ pkgs.tree-sitter-grammars.tree-sitter-nix ];
  };
}
