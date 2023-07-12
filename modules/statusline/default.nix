{ config, lib, ... }:
with lib;
let
  cfg = config.neovim.statusline;
in {
  options.neovim.statusline = {
    enable = mkEnableOption "Enables custom NeoVim status line";

    components = mkOption {
      type = types.attrsOf types.lines;
      default = {};
      description = ''
        Defines components available for the setup of status line
      '';
    };

    statusline = mkOption {
      type = types.listOf types.str;
      default = [
        "ViMode" "FileStatus" "Diagnostics" "Align"
        "SearchCount" "Align"
        "GitStatus" "FileProgress"
      ];
      description = ''
        Defines the components used in status line
      '';
    };
  };

  imports = [
    ./ViMode.nix
    ./FileProgress.nix
    ./FileStatus.nix
    ./GitStatus.nix
    ./Diagnostics.nix
    ./SearchCount.nix
    ./ShowCmd.nix
    ./TabLine.nix
  ];

  config = mkIf cfg.enable {
    neovim.startPlugins = [ "heirline" "gitsigns" ];

    neovim.statusline.components = {
      Align = "provider = \"%=\"";
    };

    neovim.initScriptLua = ''
      require('gitsigns').setup {
        watch_gitdir = {
          follow_files = true
        },
      }

      local heirline = require 'heirline'
      local heirutils = require 'heirline.utils'
      local heirconditions = require 'heirline.conditions'
      local StatuslineComponents = {
        ${concatStringsSep "," (attrsets.mapAttrsToList (n: v: "${n} = { ${v} }") cfg.components)}
      }
      heirline.setup {
        statusline = {
          ${concatStringsSep "," (map (v: "StatuslineComponents.${v}") cfg.statusline)}
        },
        tabline = heirutils.make_buflist(
          { StatuslineComponents.TabLine, { provider = " " } },
          { provider = "" },
          { provider = "" }
        ),
        opts = {
          colors = require('catppuccin.palettes').get_palette "frappe",
        },
      }
      vim.opt.laststatus = 3
      vim.opt.showtabline = 2
      -- vim.opt.showcmdloc = 'statusline'
      -- vim.opt.cmdheight = 0
    '';
  };
}
