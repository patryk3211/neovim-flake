{ lib }: {
  types = import ./types.nix { inherit lib; };
  keybind = import ./keybind.nix { inherit lib; };
  lua = import ./lua.nix { inherit lib; };
}
