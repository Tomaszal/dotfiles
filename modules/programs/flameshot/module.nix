{
  den.default.homeManager = {
    config,
    pkgs,
    pkgs-mv,
    ...
  }: let
    flameshot = pkgs-mv.tip.flameshot;
    screens = pkgs.stdenv.mkDerivation {
      name = "flameshot-screens";
      dontUnpack = true;
      nativeBuildInputs = [pkgs.pkg-config pkgs.qt6.wrapQtAppsHook];
      buildInputs = [pkgs.qt6.qtbase];
      buildPhase = ''
        runHook preBuild
        $CXX ${./screens.cpp} -o flameshot-screens $(pkg-config --cflags --libs Qt6Gui)
        runHook postBuild
      '';
      installPhase = ''
        runHook preInstall
        install -Dm755 flameshot-screens "$out/bin/flameshot-screens"
        runHook postInstall
      '';
    };
  in {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "flameshot-capture";
        runtimeInputs = [flameshot screens config.gnome-shell-rpc.package pkgs.jq];
        text = builtins.readFile ./capture.sh;
      })
    ];

    services.flameshot = {
      enable = true;
      package = flameshot;
    };

    gnome-shell-rpc.scripts.flameshot-target = {
      description = "Match the GNOME capture target to the supplied Qt screens and return its number and optional region";
      source = ./target.js;
    };

    custom-keybindings = {
      flameshot = {
        command = "flameshot-capture";
        binding = "Print";
      };
      flameshot-screen = {
        command = "flameshot-capture screen";
        binding = "<Shift>Print";
      };
      flameshot-window = {
        command = "flameshot-capture window";
        binding = "<Alt>Print";
      };
    };

    # Disable GNOME's conflicting screenshot shortcuts.
    dconf.settings."org/gnome/shell/keybindings" = {
      show-screenshot-ui = [];
      screenshot = [];
      screenshot-window = [];
    };
  };
}
