{ config, lib, ... }:
with lib;
let
  cfg = config.neovim.presence;
in {
  options.neovim.presence = {
    enable = mkEnableOption "Enabled Discord Rich Presence for NeoVim";
  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [ "presence" ];

    neovim.initScriptLua = ''
      require("presence").setup {}
    '';
  };
}
