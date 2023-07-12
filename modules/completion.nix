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
        "<C-Up>" = "cmp.mapping.scroll_docs(-4)";
        "<C-Down>" = "cmp.mapping.scroll_docs( 4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.abort()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<Tab>" = ''cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.fn["vsnip#available"](1) == 1 then
            feedkey("<Plug>(vsnip-expand-or-jump)", "")
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" })'';
        "<S-Tab>" = ''cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.fn["vsnip#jumpable"](-1) == 1 then
            feedkey("<Plug>(vsnip-jump-prev)", "")
          end
        end, { "i", "s" })'';
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
      "lspkind"
    ];

    neovim.initScriptLua = ''
      local cmp = require 'cmp';
      local lspkind = require 'lspkind';

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

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
          ${if config.neovim.treesitter.enable then "{ name = 'treesitter' }" else ""}
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
        mapping = {
          ${concatStringsSep "," (attrsets.mapAttrsToList (n: v: "['${n}'] = ${v}") cfg.keymap)}
        },
        formatting = {
          format = lspkind.cmp_format({
            with_text = true,
            menu = {
              buffer = "[Buf]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
              latex_symbols = "[LTX]",
              treesitter = "[TS]",
              wsnip = "[Snip]",
            },
          }),
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
