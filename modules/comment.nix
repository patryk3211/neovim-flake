{ config, lib, ... }:
with lib;
let
  cfg = config.neovim.comments;
in {
  options.neovim.comments = {
    enable = mkEnableOption "Enable NeoVim comments plugin";
  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [ "comments" ];

    neovim.initScriptLua = ''
      require('Comment').setup {}
    '';
  };
}
