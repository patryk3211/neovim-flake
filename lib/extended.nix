lib:
let
  nvimLib = import ./.;
in 
  lib.extend (self: super: {
    nvim = nvimLib { lib = self; };
  })
