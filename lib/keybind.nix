{ lib }:
with lib;
{
  toLua = keybinds: opts: let
    configBind = mode: keys: action: opts: let
      optsStr = "{" + 
        (concatStringsSep ","
          (attrsets.mapAttrsToList (n: v: "${n} = ${v}") opts))
        + "}";
      in "vim.keymap.set('${mode}', '${keys}', ${action}, ${optsStr})";
    configBinds = mode: binds: opts:
      concatStringsSep "\n"
        (attrsets.mapAttrsToList
          (keys: bind: let
            bindOpts = {
              noremap = if bind.noremap then "true" else "false";
            } // (if bind.description != null then { desc = "'${bind.description}'"; } else {});
            actionStr = if bind.lua then bind.bind else "\"${bind.bind}\"";
          in configBind mode keys actionStr (bindOpts//opts))
        binds);
  in ''
    ${configBinds "n" keybinds.normal opts}
    ${configBinds "i" keybinds.insert opts}
    ${configBinds "v" keybinds.visual opts}
    ${configBinds "c" keybinds.command opts}
    ${configBinds "o" keybinds.operator opts}
    ${configBinds "t" keybinds.terminal opts}
  '';
}
