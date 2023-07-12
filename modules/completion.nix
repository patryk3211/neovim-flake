{ config, lib, ... }:
with lib;
let
  cfg = config.neovim.completion;
in {
  options.neovim.completion = {
    enable = mkEnableOption "Enable NeoVim completion plugin.";

    keymap = mkOption {
      type = types.attrsOf types.str;
      default = {
        "<C-w>" = "cmp.mapping.scroll_docs(-4)";
        "<C-s>" = "cmp.mapping.scroll_docs( 4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.abort()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
      };
      description = ''
        Define keymap for the completion plugin.
      '';
    };
  };

  config = mkIf cfg.enable {
    neovim.startPlugins = [
      "nvim-cmp"
      "vim-vsnip"
      "cmp-buffer"
      "cmp-path"
      "cmp-cmdline"
      "cmp-vsnip"
    ];

    neovim.initScriptLua = ''
      local cmp = require 'cmp';
      cmp.setup {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        window = {
        },
        sources = cmp.config.sources({
          { name = 'vsnip' },
          ${if config.neovim.lsp.enable then "{ name = 'nvim_lsp' }," else ""}
        }, {
          { name = 'buffer' },
        }),
        mapping = {
          ${concatStringsSep "," (attrsets.mapAttrsToList (n: v: "['${n}'] = ${v}") cfg.keymap)}
        },
      }

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    '';

    neovim.lsp.capabilities = [ "require('cmp_nvim_lsp').default_capabilities()" ];
  };
}
