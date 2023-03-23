{
  self,
  pkgs,
  ...
}: let
  piv-agent = pkgs.buildGoModule {
    name = "piv-agent";
    src = self.inputs.piv-agent;
    vendorSha256 = "sha256-EO/rjnUFGTrajpCubR9dBHhgs3wkqlodydmXNalmTvA=";
    nativeBuildInputs = [pkgs.pkg-config];
    buildInputs = [pkgs.pcsclite];
  };
in {
  services.pcscd.enable = true;

  hm.home.packages = [piv-agent pkgs.pinentry-qt];

  environment.variables.SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/piv-agent/ssh.socket";

  hm.systemd.user.services.piv-agent = {
    Unit.Description = "piv-agent service";
    Service.ExecStart = "${piv-agent}/bin/piv-agent serve --agent-types=ssh=0;gpg=1 --touch-notify-delay=1s";
  };

  hm.systemd.user.sockets.piv-agent = {
    Unit = {
      Description = "piv-agent socket activation";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };

    Install.WantedBy = ["sockets.target"];

    Socket.ListenStream = [
      "%t/piv-agent/ssh.socket"
      "%t/gnupg/S.gpg-agent"
    ];
  };
}
