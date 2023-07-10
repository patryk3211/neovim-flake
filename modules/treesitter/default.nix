{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.neovim.treesitter;
in {
  options.neovim.treesitter = {
    enable = mkEnableOption "Enable Treesitter for NeoVim";

    grammars = mkOption {
      type = types.listOf types.package;
      default = [];
      description = ''
        List of treesitter grammars to install.
      '';
    };
  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [ "nvim-treesitter" ]
    ++ (if config.neovim.completion.enable then [ "cmp-treesitter" ] else []);

    neovim.initScriptLua = ''
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
          disable = {},
        },

        auto_install = false,
        ensure_installed = {},
      }
    '';
  };

  imports = [
    ./context.nix
  ];
}
