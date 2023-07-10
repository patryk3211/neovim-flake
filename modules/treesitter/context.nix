{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.neovim.treesitter.context;
in {
  options.neovim.treesitter.context = {
    enable = mkEnableOption "Enable Treesitter context for NeoVim";
  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [ "nvim-treesitter-context" ];

    neovim.initScriptLua = ''
      require('treesitter-context').setup {
        enable = true;

      }
    '';
  };
}
