{ config, lib, ... }:
with lib;
let
  cfg = config.neovim.trouble;
in {
  options.neovim.trouble = {
    enable = mkEnableOption "Enables NeoVim Trouble plugin";
  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [ "trouble" ];

    neovim.initScriptLua = ''
      require('trouble').setup {
      }
    '';

    neovim.keymap = mkDefault {
      normal = {
        "<Space>q" = {
          bind = ":TroubleToggle<CR>";
          description = "Opens the trouble window";
          silent = true;
        };
      };
    };
  };
}
