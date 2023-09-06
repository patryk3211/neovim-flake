{ config, lib, ... }:
with lib;
let
  cfg = config.neovim;
  setOption = optionName: state: "set ${if state then "" else "no"}${optionName}";
in {
  options.neovim = {
    lineNumber = mkOption {
      type = types.bool;
      default = true;
    };

    tabWidth = mkOption {
      type = types.int;
      default = 4;
    };

    expandTab = mkOption {
      type = types.bool;
      default = true;
    };

    cursorLine = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = {
    neovim.initScript = ''
      ${setOption "number" cfg.lineNumber}
      ${setOption "cursorline" cfg.cursorLine}

      ${setOption "expandtab" cfg.expandTab}
      set tabstop=${toString cfg.tabWidth}
      set shiftwidth=${toString cfg.tabWidth}
      set softtabstop=${toString cfg.tabWidth}

      let g:default_tab_size = 4
      let g:tab_sizes = { }
      function s:set_shift_width(filetype)
          let l:size = get(g:tab_sizes, a:filetype, g:default_tab_size)
          exec 'set shiftwidth='.l:size
          exec 'set tabstop='.l:size
          exec 'set softtabstop='.l:size
      endfunction
      autocmd FileType * call s:set_shift_width(expand('<amatch>'))
    '';
  };
}
