{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.neovim.language.cpp;
in {
  options.neovim.language.cpp = {
    enable = mkEnableOption "Enable C/C++ language for NeoVim";
  };

  config = mkIf cfg.enable {
    neovim.lsp.servers = [{
      name = "ccls";
      executable = "ccls";
      args = {
        init_options = {
          compilationDatabaseDirectory = "build";
          index = {
            threads = 0;
          };
          clang = {
            excludeArgs = [ "-frounding-math" ];
          };
        };
      };
      package = pkgs.ccls;
    }];
  };
}
