{ config, pkgs, lib, ...}:
with lib;
let
  cfg = config.neovim.theme;
in {
  options.neovim.theme = {
    enable = mkEnableOption "Enable NeoVim theme";

    plugin = mkOption {
      type = types.str;
      default = "catppuccin";
    };

    name = mkOption {
      type = types.str;
      default = "catppuccin-frappe";
    };
  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [ cfg.plugin ];
    neovim.initScript = ''
      colorscheme ${cfg.name}
    '';
    neovim.initScriptLua = ''
      require('catppuccin').setup {
        integrations = {
          neotree = true,
          which_key = true,

          dap = {
            enabled = true,
            enable_ui = true,
          },
        },
      }
    '';
  };
}
