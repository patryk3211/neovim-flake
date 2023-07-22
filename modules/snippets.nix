{ config, lib, ... }:
with lib;
let
  cfg = config.neovim.snippets;
in {
  options.neovim.snippets = {
    enable = mkEnableOption "Enable NeoVim snippets";
  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [ "friendly-snippets" ];
  };
}
