{ modules ? [],
  check ? true,
  lib, pkgs, ... }:
let
  nvimModules = import ./modules {
    inherit pkgs lib check;
  };

  module = lib.evalModules {
    modules = modules ++ nvimModules;
    specialArgs = {
      modulesPath = toString ./modules;
      currentModules = modules;
    };
  };
in
  module.config.output.package
