{ config, lib, ... }:
with lib;
let
  cfg = config.neovim.icons;
in {
  options.neovim.icons = {
    enable = mkEnableOption "Enable NeoVim Icons";
  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [ "nvim-web-devicons" ];

    neovim.initScript = ''
      sign define DiagnosticSignError text= texthl=DiagnosticSignError
      sign define DiagnosticSignWarn text= texthl=DiagnosticSignWarn
      sign define DiagnosticSignInfo text= texthl=DiagnosticSignInfo
      sign define DiagnosticSignHint text= texthl=DiagnosticSignHint

      sign define DapLogPoint text= texthl=DapLogPoint
      sign define DapStopped text=→ linehl=debugPC
      sign define DapBreakpoint text= texthl=DapBreakpoint
      sign define DapBreakpointCondition text= texthl=DapBreakpointCondition
      sign define DapBreakpointRejected text=
    '';
  };
}
