{lib, ...}: {
  den.aspects.dev = {
    homeManager = {pkgs-mv, ...}: {
      home.packages = with pkgs-mv.tip; [proto];

      programs.fish.interactiveShellInit = lib.mkAfter ''
        proto activate fish | source
      '';
    };

    nixos.environment.sessionVariables.PATH = [
      "$HOME/.local/share/proto/bin"
    ];
  };
}
