{lib, ...}: {
  # Wayland exposes no way to script the compositor, and gnome-shell's own
  # `org.gnome.Shell.Eval` is inert unless `global.context.unsafe_mode` is set,
  # which has to be flipped by hand in Looking Glass and resets on lock. The
  # usual workaround is one bespoke extension per automation; this is one
  # extension whose callable surface is declared by `gnome-shell-rpc.scripts`.
  #
  # Nothing is ever `eval`ed: a caller can only name one of the modules this
  # flake generated. An extension exporting a generic `Eval` would instead hand
  # code execution inside gnome-shell to anything that can reach the session
  # bus, which is why GNOME gated the built-in one.
  den.default.homeManager = {
    pkgs,
    config,
    ...
  }: let
    inherit (lib) mkOption mkIf types;
    inherit (lib.attrsets) mapAttrs mapAttrsToList;
    inherit (lib.strings) replaceStrings;
    inherit (lib.versions) major;

    inherit (config.gnome-shell-rpc) scripts;

    uuid = "gnome-shell-rpc@tomaszal.com";
    interface = "com.tomaszal.GnomeShellRpc";
    objectPath = "/com/tomaszal/GnomeShellRpc";
    extensionPath = "share/gnome-shell/extensions/${uuid}";

    # Descriptions do not affect imported modules, so only source changes and
    # additions/removals advance the cache key.
    version =
      builtins.hashString "sha256"
      (builtins.toJSON (mapAttrs (_: script: builtins.hashFile "sha256" script.source) scripts));

    scriptModules = mapAttrsToList (name: script:
      pkgs.writeTextDir
      "${extensionPath}/scripts/${name}.js"
      (builtins.readFile script.source))
    scripts;

    extensionJs =
      replaceStrings
      ["@interface@" "@objectPath@"]
      [interface objectPath]
      (builtins.readFile ./extension.js);

    extension = pkgs.symlinkJoin {
      name = "gnome-shell-extension-rpc";
      paths =
        scriptModules
        ++ [
          (pkgs.writeTextDir "${extensionPath}/extension.js" extensionJs)

          (pkgs.writeTextDir "${extensionPath}/metadata.json" (builtins.toJSON {
            inherit uuid;
            name = "Shell RPC";
            description = "Runs GJS scripts declared by the system flake, over D-Bus.";
            # Declare compatibility with the shell major in this system closure.
            shell-version = [(major pkgs.gnome-shell.version)];
          }))

          (pkgs.writeTextDir "${extensionPath}/scripts/index.json" (builtins.toJSON {
            inherit version;
            scripts = mapAttrs (_: script: script.description) scripts;
          }))
        ];
    };

    client = pkgs.writeShellApplication {
      name = "gnome-shell-rpc";
      runtimeInputs = with pkgs; [jq systemd];
      text =
        replaceStrings
        ["@interface@" "@objectPath@"]
        [interface objectPath]
        (builtins.readFile ./client.sh);
    };
  in {
    options.gnome-shell-rpc = {
      scripts = mkOption {
        default = {};
        description = "GJS scripts callable inside gnome-shell over D-Bus.";
        type = types.attrsOf (types.submodule {
          options = {
            description = mkOption {
              type = types.str;
              default = "";
              description = "Summary listed by `gnome-shell-rpc --list`.";
            };

            source = mkOption {
              type = types.path;
              description = ''
                GJS module exporting a default async function. It receives the
                parsed JSON argument object, and its return value is serialised
                to JSON for the caller.
              '';
            };
          };
        });
      };

      package = mkOption {
        type = types.package;
        readOnly = true;
        default = client;
        description = "The client, for consumers to put on their own `PATH`.";
      };
    };

    config = mkIf (scripts != {}) {
      home.packages = [extension client];

      # Script names reach both a file name and a D-Bus argument, so reject
      # anything awkward up front instead of at call time.
      assertions =
        mapAttrsToList (name: _: {
          assertion = builtins.match "[a-z0-9][a-z0-9-]*" name != null;
          message = ''gnome-shell-rpc.scripts."${name}": name must match [a-z0-9][a-z0-9-]*'';
        })
        scripts;
    };
  };
}
