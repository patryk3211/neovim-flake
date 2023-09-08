{ lib, pkgs, check ? true, ... }:
let
  modules = [
    ./base.nix

    ./theme.nix
    ./icons.nix
    ./basic.nix
    ./lsp
    ./dap
    ./which-key.nix
    ./completion.nix
    ./languages
    ./treesitter
    ./statusline
    ./fileexplorer.nix
    ./comment.nix
    ./trouble.nix
    ./commands.nix
    ./snippets.nix
    ./presence.nix

    ./build.nix
  ];

  pkgsModule = { config, ... }: {
    config = {
      _module.args.baseModules = modules;
      _module.args.pkgsPath = lib.mkDefault pkgs.path;
      _module.args.pkgs = lib.mkDefault pkgs;
      _module.check = check;
    };
  };
in
  modules ++ [pkgsModule]
