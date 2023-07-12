{ config, lib, pkgs, ... }:
with lib;
let
  buildCfg = config.build;
  outputCfg = config.output;
  nvimCfg = config.neovim;

  inputsSubmodule = {...}: {
    options.src = mkOption {
      type = types.package;
    };
  };
in {
  options.build = {
    viAlias = mkOption {
      type = types.bool;
      default = true;
    };

    vimAlias = mkOption {
      type = types.bool;
      default = true;
    };

    rawPlugins = mkOption {
      type = types.attrsOf (types.submodule inputsSubmodule);
      default = {};
    };

    package = mkOption {
      type = types.package;
      default = pkgs.neovim-unwrapped;
      description = ''
        NeoVim package to use.
      '';
    };
  };

  options.output = {
    initScript = mkOption {
      type = types.lines;
      readOnly = true;
    };

    startPlugins = mkOption {
      type = types.listOf types.package;
      readOnly = true;
    };

    dependencies = mkOption {
      type = types.listOf types.package;
      readOnly = true;
    };

    package = mkOption {
      type = types.package;
      readOnly = true;
    };
  };
  
  config = let
    buildPlugin = name: pkgs.vimUtils.buildVimPluginFrom2Nix rec {
      pname = name;
      version = "master";
      src = assert asserts.assertMsg (name != "nvim-treesitter") "Use buildTreesitterPlug for building nvim-treesitter.";
        buildCfg.rawPlugins.${pname}.src;
    };

    buildPlugins = plugins:
      map (p:
        if isString p then
          if p == "nvim-treesitter" then
            pkgs.vimPlugins.nvim-treesitter.withPlugins (_: config.neovim.treesitter.grammars)
          else
            buildPlugin p
        else
          p
      ) (filter (f: f != null) plugins);

    allPlugins = outputCfg.startPlugins;

    neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
      inherit (buildCfg);
  
      plugins = allPlugins;
      customRC = outputCfg.initScript;
    };
  in {
    output = {
      startPlugins = buildPlugins (lists.unique nvimCfg.startPlugins);

      dependencies = nvimCfg.lsp.lspBinaries;

      initScript = ''
        ${nvimCfg.initScript}

        let localrc = getcwd() . '/.vimrc'
        if filereadable(localrc)
          execute 'source '.localrc
        endif

        lua << EOF
        ${nvimCfg.initScriptLua}
        EOF
      '';

      package = (pkgs.wrapNeovimUnstable buildCfg.package (neovimConfig // {
        wrapRc = true;
      })).overrideAttrs(oldAttrs: {
        propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or []) ++ outputCfg.dependencies;
      });
    };
  };
}
