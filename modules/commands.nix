{ config, lib, ... }:
with lib;
let
  cfg = config.neovim.commands;

  command = {...}: {
    options = {
      cmd = mkOption {
        type = types.str;
      };
    };
  };
in {
  options.neovim.commands = mkOption {
    type = types.attrsOf (types.submodule command);
    default = {
      Stage = { cmd = "!git add *"; };
    };
    example = {
      Hello = { cmd = "echo \"Hello\""; };
    };
  };

  config = {
    neovim.initScript = ''
      ${concatStringsSep "\n" (attrsets.mapAttrsToList (n: v:
        "command ${n} ${v.cmd}"
      ) cfg)}
    '';
  };
}

