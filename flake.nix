{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Theme
    catppuccin = {
      url = "github:catppuccin/nvim";
      flake = false;
    };

    # LSP
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    # Debugging
    nvim-dap = {
      url = "github:mfussenegger/nvim-dap";
      flake = false;
    };

    # Treesitter
    nvim-treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };

    # Status line
    heirline = {
      url = "github:rebelot/heirline.nvim";
      flake = false;
    };

    # A nicer diagnostics menu
    trouble = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };

    # Git
    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    # File explorer
    neo-tree = {
      url = "github:nvim-neo-tree/neo-tree.nvim";
      flake = false;
    };

    # Completion
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-cmdline = {
      url = "github:hrsh7th/cmp-cmdline";
      flake = false;
    };
    cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };

    # LSP kind
    lspkind = {
      url = "github:onsails/lspkind.nvim";
      flake = false;
    };

    # Icons
    nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };

    # Snippets
    vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };
    friendly-snippets = {
      url = "github:rafamadriz/friendly-snippets";
      flake = false;
    };

    # Utilities
    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    # Comment toggler
    comments = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };

    # Other things
    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    nui = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };

    nil = {
      # url = "github:oxalica/nil?rev=18de045d7788df2343aec58df7b85c10d1f5d5dd";
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    presence = {
      url = "github:andweeb/presence.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, nil, ... }@inputs:
  let
    rawPlugins = nvimLib.attrsets.mapAttrs (n: v: { src = v; }) inputs;

    nvimLib = import ./lib/extended.nix nixpkgs.lib;
    nvimConfig = { modules ? [], ... }@args:
      import ./default.nix (args // {modules = [{config.build.rawPlugins = rawPlugins;}] ++ modules;});

    makePkg = pkgs: modules: (nvimConfig {
      inherit pkgs modules;
      lib = nvimLib;
    });

    nixCfg = let
      override = nvimLib.mkOverride 1200;
    in {
      config.neovim = {
        theme.enable = override true;
        icons.enable = override true;

        lsp.enable = override true;
        treesitter.enable = override true;
        treesitter.context.enable = override true;
        completion.enable = override true;
        snippets.enable = override true;

        which-key.enable = override true;

        statusline.enable = override true;

        fileexplorer.enable = override true;

        comments.enable = override true;

        trouble.enable = override true;

        presence.enable = override true;

        language = {
          nix.enable = override true;
          lua.enable = override true;
          rust.enable = override true;
          cpp.enable = override true;
          python.enable = override true;
        };
      };
    };

  in {
    # General flake output stuff
    lib = nvimLib;

    overlays.default = final: prev: {
      neovim = makePkg prev;
    };
  } // flake-utils.lib.eachDefaultSystem (system: let
    pkgs = (import nixpkgs { inherit system; overlays = [
      nil.overlays.default
    ]; });

    nvimPkg = makePkg pkgs [nixCfg];
    nvimBin = pkg: "${pkg}/bin/nvim";
  in {
    # Per system outputs
    apps = {
      default = {
        type = "app";
        program = nvimBin nvimPkg;
      };
    };

    packages = {
      default = nvimPkg;
    };
  });
}
