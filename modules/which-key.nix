{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.neovim.which-key;
in {
  options.neovim.which-key = {
    enable = mkEnableOption "Enable which-key plugin";

    timeout = mkOption {
      type = types.int;
      default = 500;
    };
  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [ "which-key" ];
    neovim.initScriptLua = ''
      vim.o.timeout = true
      vim.o.timeoutlen = ${toString cfg.timeout}
      require('which-key').setup {}
    '';
  };
}
