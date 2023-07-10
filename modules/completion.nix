{ config, lib, ... }:
with lib;
let
  cfg = config.neovim.completion;
in {
  options.neovim.completion = {
    enable = mkEnableOption "Enable NeoVim completion plugin.";
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
        }, {
          { name = 'buffer' },
        }),
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
