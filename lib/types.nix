{ lib }:
with lib;
rec {
  keybind = types.submodule ({...}: {
    options = {
      bind = mkOption {
        type = types.str;
        description = "Action of the keybind";
      };

      lua = mkOption {
        type = types.bool;
        description = "Is the rhs of this mapping Lua code";
        default = false;
      };

      noremap = mkOption {
        type = types.bool;
        description = "What happens if the mapping already exists";
        default = false;
      };

      description = mkOption {
        type = types.nullOr types.str;
        description = "Human readable description of the keybind";
        default = null;
      };
    };
  });

  keybindsModes = types.submodule ({...}: let
    mkMapOption = desc: mkOption {
      type = types.attrsOf keybind;
      description = desc;
      default = {};
    };
  in {
    options = {
      normal = mkMapOption "Keybinds for Normal mode";
      insert = mkMapOption "Keybinds for Insert and Replace mode";
      visual = mkMapOption "Keybinds for Visual and Select mode";
      command = mkMapOption "Keybinds for Command-line mode";
      operator = mkMapOption "Keybinds for Operator pending mode";
      terminal = mkMapOption "Keybinds for Terminal mode";
    };
  });

  lspServer = types.submodule ({...}: {
    options = {
      name = mkOption {
        type = types.str;
        description = ''
          Name of the language server.
        '';
      };

      args = mkOption {
        type = types.attrsOf types.anything;
        description = ''
          Arguments for the setup function.
        '';
      };

      executable = mkOption {
        type = types.str;
        description = ''
          Executable used to start the language server binary.
        '';
      };

      package = mkOption {
        type = types.package;
        description = ''
          Package providing the language server binary.
        '';
      };
    };
  });
}
