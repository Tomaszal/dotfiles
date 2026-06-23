{
  inputs,
  lib,
  ...
}: let
  version = "0.23.0";
in {
  flake-file.inputs.piv-agent = {
    flake = false;
    url = "github:smlx/piv-agent/v${version}";
  };

  den.default = {
    nixos = {
      services.pcscd.enable = true;

      # Disable default GNOME SSH agent
      services.gnome.gcr-ssh-agent.enable = false;
    };

    homeManager = {
      config,
      nixosConfig,
      pkgs,
      ...
    }: let
      piv-agent = pkgs.buildGoModule {
        inherit version;
        src = inputs.piv-agent;
        pname = "piv-agent";

        vendorHash = "sha256-4yfQQxMf00263OKEXTWD34YifK7oDclvPk8JDz5N1I0=";

        nativeBuildInputs = [pkgs.pkg-config];
        buildInputs = [pkgs.pcsclite];

        meta = {
          description = "An SSH and GPG agent which you can use with your PIV hardware security device (e.g. a Yubikey).";
          license = lib.licenses.asl20;
          homepage = "https://smlx.github.io/piv-agent/";
        };
      };

      # Pinentry package which will be used
      inherit (nixosConfig.programs.gnupg.agent) pinentryPackage;

      # Exit after this period to drop transaction and key file passphrase cache, even if service is in use
      exitTimeout = "12h";

      # Exit after this period of disuse
      idleTimeout = "30m";

      # Display a notification after this period when waiting for a touch
      touchNotifyDelay = "100ms";

      # Agent types to handle
      agent = {
        ssh = true;
        gpg = true;
      };

      agentList = lib.pipe agent [
        lib.attrsets.attrsToList
        (builtins.filter ({value, ...}: value == true))
      ];
    in {
      home.packages = [piv-agent];

      systemd.user.services.piv-agent = {
        Unit.Description = "piv-agent service";

        Service.ExecSearchPath = lib.makeBinPath [
          piv-agent
          pinentryPackage
        ];

        Service.ExecStart = let
          agentIndexes =
            lib.concatImapStringsSep ";"
            (index: {name, ...}: "${name}=${toString (index - 1)}")
            agentList;
        in ''
          piv-agent serve \
            --exit-timeout=${exitTimeout} \
            --idle-timeout=${idleTimeout} \
            --touch-notify-delay=${touchNotifyDelay} \
            --agent-types=${agentIndexes}
        '';
      };

      systemd.user.sockets.piv-agent = {
        Unit.Description = "piv-agent socket activation";

        Install.WantedBy = ["sockets.target"];

        Socket.DirectoryMode = "0700";

        Socket.ListenStream = let
          agentSocket = {
            ssh = "%t/piv-agent/ssh.socket";
            gpg = "%t/gnupg/S.gpg-agent";
          };
        in
          map ({name, ...}: agentSocket.${name}) agentList;
      };

      # SSH integration
      home.sessionVariablesExtra = lib.mkIf agent.ssh ''
        if [[ -z "$SSH_AUTH_SOCK" ]]; then
          export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/piv-agent/ssh.socket
        fi
      '';

      # GPG integration
      home.file."${config.programs.gpg.homedir}/gpg.conf".text = lib.mkIf agent.gpg (lib.mkForce "no-autostart");
      services.gpg-agent.enable = lib.mkIf agent.gpg (lib.mkForce false);
    };
  };
}
