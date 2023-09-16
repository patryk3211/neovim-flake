{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.neovim.dap.ui;
in {
  options.neovim.dap.ui = {
    enable = mkEnableOption "Enable dap-ui plugin";
  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [ "nvim-dap-ui" ];

    neovim.initScriptLua = ''
      local dap = require 'dap'
      local dapui = require 'dapui'

      dapui.setup {}

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      vim.api.nvim_create_user_command('DapEval', function(opts)
          dapui.eval(opts[1])
      end, { nargs = 1 })
    '';
  };
}
