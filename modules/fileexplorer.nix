{ config, lib, ... }:
with lib;
let
  cfg = config.neovim.fileexplorer;
in {
  options.neovim.fileexplorer = {
    enable = mkEnableOption "Enable NeoVim file explorer";
  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [ "nui" "plenary" "nvim-web-devicons" "neo-tree" ];

    neovim.initScriptLua = ''
      vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

      require('neo-tree').setup {
        close_if_last_window = false,
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
        sort_case_insensitive = false,

        default_component_configs = {
          container = {
            enable_character_fade = true,
          },
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = '│',
            last_indent_marker = '└',
            highlight = 'NeoTreeIndentMarker',
            with_expanders = nil,
            expander_collapsed = '',
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󰜌",
            folder_empty_open = "󰜌",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              added     = "✚", 
              modified  = "", 
              deleted   = "✖",
              renamed   = "",
              untracked = "",
              ignored   = "",
              unstaged  = "󰄱",
              staged    = "",
              conflict  = "",
            },
          },
          document_symbols = {
            kinds = {
              File = { icon = "󰈙", hl = "Tag" },
              Namespace = { icon = "󰌗", hl = "Include" },
              Package = { icon = "󰏖", hl = "Label" },
              Class = { icon = "󰌗", hl = "Include" },
              Property = { icon = "󰆧", hl = "@property" },
              Enum = { icon = "󰒻", hl = "@number" },
              Function = { icon = "󰊕", hl = "Function" },
              String = { icon = "󰀬", hl = "String" },
              Number = { icon = "󰎠", hl = "Number" },
              Array = { icon = "󰅪", hl = "Type" },
              Object = { icon = "󰅩", hl = "Type" },
              Key = { icon = "󰌋", hl = "" },
              Struct = { icon = "󰌗", hl = "Type" },
              Operator = { icon = "󰆕", hl = "Operator" },
              TypeParameter = { icon = "󰊄", hl = "Type" },
              StaticMethod = { icon = '󰠄 ', hl = 'Function' },
            }
          },
        },

        filesystem = {
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,

            hide_by_name = {
              ".git",
            },
          },
        },
      }
    '';

    neovim.keymap = mkDefault {
      normal = {
        "<Space>e" = {
          bind = ":Neotree toggle<CR>";
          description = "Opens file explorer in sidebar";
          silent = true;
          noremap = true;
        };
      };
    };
  };
}
