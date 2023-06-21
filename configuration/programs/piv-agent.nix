{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  piv-agent = pkgs.buildGoModule {
    name = "piv-agent";
    src = self.inputs.piv-agent;
    vendorSha256 = "sha256-KKARL/I2u69qz5Z2UhefAZj2OY/Zlk0geiB0/xWZAjA=";
    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = [pkgs.pcsclite];
  };
in {
  services.pcscd.enable = true;

  hm.home.packages = [piv-agent pkgs.pinentry-qt];

  # PIV agent service
  hm.systemd.user.services.piv-agent = {
    Unit.Description = "piv-agent service";
    Service.ExecStart = "${piv-agent}/bin/piv-agent serve --agent-types=ssh=0;gpg=1 --touch-notify-delay=1s";
  };

  # PIV agent socket activation for SSH and GPG
  hm.systemd.user.sockets.piv-agent = {
    Unit = {
      Description = "piv-agent socket activation";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };

    Install.WantedBy = ["sockets.target"];

    Socket = {
      ListenStream = [
        "%t/piv-agent/ssh.socket"
        "%t/gnupg/S.gpg-agent"
      ];

      # GPG is picky about permissions
      DirectoryMode = "0700";
    };
  };

  # SSH integration
  hm.home.sessionVariables.SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/piv-agent/ssh.socket";

  # GPG integration
  hm.home.file."${config.hm.programs.gpg.homedir}/gpg.conf".text = lib.mkForce "no-autostart";
  hm.services.gpg-agent.enable = lib.mkForce false;
}
