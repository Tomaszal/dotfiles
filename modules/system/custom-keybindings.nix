{lib, ...}:
with lib; {
  den.default.homeManager = {config, ...}: {
    options.custom-keybindings = mkOption {
      type = types.attrsOf (types.submodule ({name, ...}: {
        options = {
          name = mkOption {
            type = types.str;
            default = name;
          };
          command = mkOption {
            type = types.str;
          };
          binding = mkOption {
            type = types.str;
          };
          enable-in-lockscreen = mkOption {
            type = types.bool;
            default = false;
          };
        };
      }));
    };

    config = let
      inherit (config) custom-keybindings;

      path = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings";

      settings = mapAttrs' (name: value: nameValuePair "${path}/${name}" value) custom-keybindings;

      media-keys = {
        "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings =
          map (name: "/${path}/${name}/") (attrNames custom-keybindings);
      };
    in {
      dconf.settings = settings // media-keys;
    };
  };
}
