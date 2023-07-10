{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.neovim.language.rust;
in {
  options.neovim.language.rust = {
    enable = mkEnableOption "Enable Rust language configuration";
  };

  config = mkIf cfg.enable {
    neovim.lsp.servers = [{
      name = "rust_analyzer";
      executable = "rust-analyzer";
      args = {};
      package = pkgs.rust-analyzer;
    }];

    neovim.treesitter.grammars = [ pkgs.tree-sitter-grammars.tree-sitter-rust ];
  };
}
