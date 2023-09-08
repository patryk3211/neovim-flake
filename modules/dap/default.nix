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
        "<Space>dL" = {
          bind = "require('dap').run_last";
          lua = true;
          noremap = true;
          description = "Run last configuration";
        };
        "<Space>dT" = {
          bind = "require('dap').terminate";
          lua = true;
          noremap = true;
          description = "Terminate running configuration";
        };
        "<Space>dC" = {
          bind = "require('dap').clear_breakpoints";
          lua = true;
          noremap = true;
          description = "Clear all breakpoints";
        };
      };
    };

    neovim.initScriptLua = ''
        vim.api.nvim_create_user_command('DapBreak', function(opts)
            require('dap').set_breakpoint(opts[1])
        end, { nargs = 1 })
        vim.api.nvim_create_user_command('DapListPoints', require('dap').list_breakpoints, {})
    '';
  };
}
