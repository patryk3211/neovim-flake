{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.neovim.language.cmake;
in {
  options.neovim.language.cmake = {
    enable = mkEnableOption "Enable CMake language for NeoVim";
  };

  config = mkIf cfg.enable {
    neovim.lsp.servers = [{
      name = "cmake";
      executable = "cmake-language-server";
      args = {
        init_options = {
          buildDirectory = "build";
        };
      };
      package = pkgs.cmake-language-server;
    }];
  };
}
