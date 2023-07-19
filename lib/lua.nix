{ lib }:
rec {
  wrapFunction = lua:
  ''function()
      ${lua}
    end'';

  toString = v:
    if lib.isString v then
      "'${v}'"
    else if lib.isBool v then
      if v then "true" else "false"
    else if lib.isList v then
      "{${lib.concatStringsSep "," (map (e: toString e) v)}}"
    else if lib.isAttrs v then
      if v?__lua__ then
        v.__lua__
      else
        "{${lib.concatStringsSep "," (lib.attrsets.mapAttrsToList (n: e: "${n}=${toString e}") v)}}"
    else if isNull v then
      "nil"
    else if (lib.isInt v) || (lib.isFloat v) then
      "${builtins.toString v}"
    else throw "Undefined type";
}
