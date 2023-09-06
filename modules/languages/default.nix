{ config, pkgs, lib, ... }:

{
  imports = [
    ./nix.nix
    ./lua.nix
    ./rust.nix
    ./cpp.nix
    ./python.nix
    ./cmake.nix
  ];
}
