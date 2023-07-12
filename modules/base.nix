{ config, lib, ... }:
with lib;
let
  cfg = config.neovim;

  makeMapOption = desc: mkOption {
    type = types.attrsOf (types.nullOr nvim.types.keybind);
    default = {};
    description = desc;
  };
in {
  options.neovim = {
    initScript = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Vim script part of the init script
      '';
    };

    initScriptLua = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Lua script part of the init script
      '';
    };

    startPlugins = mkOption {
      type = types.listOf types.str;
      default = [];
    };

    keymap = mkOption {
      type = nvim.types.keybindsModes;
      description = ''
        Defines global keybinds
      '';
      default = {};
    };
  };

  config = let
  in {
    neovim.initScriptLua = ''
      ${nvim.keybind.toLua cfg.keymap {}}
    '';

    neovim.keymap = mkDefault {
      normal = {
        "<Space>hl" = {
          bind = ":nohl<CR>";
          description = "Disable highlights";
          silent = true;
          noremap = true;
        };
      };
    };
  };
}
