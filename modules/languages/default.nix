{ config, pkgs, lib, ... }:

{
  imports = [
    ./nix.nix
    ./lua.nix
    ./rust.nix
  ];
}
