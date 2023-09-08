{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.neovim.dap;
in {
  imports = [
  ];

  options.neovim.dap = {
    enable = mkEnableOption "Enable NeoVim debug adapter protocol";

  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [ "nvim-dap" ];

    neovim.keymap = mkDefault {
      normal = {
        "<Space>db" = {
          bind = "require('dap').toggle_breakpoint";
          lua = true;
          noremap = true;
          description = "Toggle breakpoint";
        };
        "<Space>dc" = {
          bind = "require('dap').continue";
          lua = true;
          noremap = true;
          description = "Continue execution";
        };
        "<Space>dsi" = {
          bind = "require('dap').step_into";
          lua = true;
          noremap = true;
          description = "Step into";
        };
        "<Space>dso" = {
          bind = "require('dap').step_over";
          lua = true;
          noremap = true;
          description = "Step over";
        };
      };
    };
  };
}
