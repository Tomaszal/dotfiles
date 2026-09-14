{
  den.default.homeManager = {
    config,
    pkgs,
    pkgs-mv,
    ...
  }: let
    flameshot = pkgs-mv.tip.flameshot;
  in {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "flameshot-capture";
        runtimeInputs = [flameshot config.gnome-shell-rpc.package pkgs.jq];
        text = builtins.readFile ./capture.sh;
      })
    ];

    services.flameshot = {
      enable = true;
      package = flameshot;
    };

    gnome-shell-rpc.scripts.flameshot-target = {
      description = "Flameshot screen number and optional region for the requested capture mode";
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
