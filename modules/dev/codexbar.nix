{
  den.aspects.dev.codexbar.homeManager = {
    config,
    lib,
    pkgs,
    sources,
    ...
  }: let
    codexbar = pkgs.stdenvNoCC.mkDerivation {
      inherit (sources.codexbar) pname src;
      version = lib.removePrefix "v" sources.codexbar.version;

      sourceRoot = ".";

      nativeBuildInputs = [
        pkgs.autoPatchelfHook
        pkgs.makeWrapper
      ];
      buildInputs = with pkgs; [
        curl
        sqlite
        stdenv.cc.cc
      ];

      installPhase = ''
        install -dm755 $out/libexec/codexbar
        cp -r CodexBarCLI CodexBar_CodexBarCore.bundle $out/libexec/codexbar/
        install -dm755 $out/bin
        makeWrapper $out/libexec/codexbar/CodexBarCLI $out/bin/codexbar \
          --prefix LD_PRELOAD : ${pkgs.libredirect}/lib/libredirect.so \
          --prefix NIX_REDIRECTS : /usr/bin/which=${pkgs.which}/bin/which
      '';
    };

    codexbar-token = pkgs.writeShellApplication {
      name = "codexbar-token";
      text = ''
        token_file="''${XDG_CONFIG_HOME:-$HOME/.config}/codexbar/serve.env"
        if [[ ! -r "$token_file" ]]; then
          echo "CodexBar dashboard token is not available" >&2
          exit 1
        fi

        IFS= read -r token < "$token_file"
        printf '%s\n' "''${token#CODEXBAR_DASHBOARD_TOKEN=}"
      '';
    };

    inherit (config.codexbar) providers;

    entry = provider:
      {
        inherit (provider) id;
        enabled = provider.enable;
      }
      // lib.optionalAttrs (provider.source != null) {inherit (provider) source;}
      // provider.settings;
  in {
    options.codexbar.providers = with lib;
      mkOption {
        type = types.attrsOf (types.submodule ({name, ...}: {
          options = {
            id = mkOption {
              type = types.str;
              default = name;
              description = "Provider identifier, as listed in CodexBar's provider IDs.";
            };
            enable = mkOption {
              type = types.bool;
              default = true;
              description = "Whether to query this provider when none is requested explicitly.";
            };
            source = mkOption {
              type = types.nullOr (types.enum ["auto" "web" "cli" "oauth" "api"]);
              default = null;
              description = "Preferred source mode, or null to keep the provider default.";
            };
            settings = mkOption {
              type = types.attrsOf types.anything;
              default = {};
              description = ''
                Extra provider fields merged into the entry, such as `enterpriseHost`,
                `region`, or `workspaceID`.

                The generated file lives in the world-readable Nix store, so never set
                secrets like `apiKey` or `cookieHeader` here.
              '';
            };
          };
        }));
        default = {};
        description = ''
          Providers written to CodexBar's `config.json`.

          The file is managed declaratively, so `codexbar config` subcommands cannot
          write to it.
        '';
      };

    config = {
      home.packages = [codexbar codexbar-token];

      home.activation.codexbarDashboardToken = lib.hm.dag.entryAfter ["writeBoundary"] ''
        token_file="${config.xdg.configHome}/codexbar/serve.env"
        if [[ ! -s "$token_file" ]]; then
          install -m 0700 -d "$(dirname "$token_file")"
          token="$(${pkgs.openssl}/bin/openssl rand -hex 32)"
          printf 'CODEXBAR_DASHBOARD_TOKEN=%s\n' "$token" > "$token_file"
        fi
        chmod 0600 "$token_file"
      '';

      systemd.user.services.codexbar = {
        Unit = {
          Description = "CodexBar cached quota server";
          After = ["network-online.target"];
          Wants = ["network-online.target"];
        };
        Service = {
          EnvironmentFile = "%h/.config/codexbar/serve.env";
          ExecStart = ''
            ${codexbar}/bin/codexbar serve \
              --host 127.0.0.1 \
              --port 8765 \
              --identity full
          '';
          Restart = "on-failure";
          RestartSec = 5;
        };
        Install.WantedBy = ["default.target"];
      };

      xdg.configFile."codexbar/config.json" = lib.mkIf (providers != {}) {
        source = (pkgs.formats.json {}).generate "codexbar-config.json" {
          version = 1;
          providers = lib.mapAttrsToList (_: entry) providers;
        };
      };
    };
  };
}
