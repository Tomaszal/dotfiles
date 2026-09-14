{lib, ...}: {
  den.aspects.dev = {
    homeManager = {pkgs-unstable, ...}: {
      home.packages = with pkgs-unstable; [proto];

      programs.fish.interactiveShellInit = lib.mkAfter ''
        proto activate fish | source
      '';
    };

    nixos.environment.sessionVariables.PATH = [
      "$HOME/.local/share/proto/bin"
    ];
  };
}
