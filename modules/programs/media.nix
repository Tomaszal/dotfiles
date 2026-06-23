{den, ...}: {
  den.default = {
    includes = [(den.batteries.unfree ["spotify"])];

    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        pinta
        spotify
        vlc
      ];

      programs.obs-studio.enable = true;
    };
  };

  # TODO: get flameshot from flake as it's currently broken otherwise
  den.aspects.media.flameshot.homeManager = {pkgs, ...}: {
    services.flameshot.enable = true;

    # https://github.com/flameshot-org/flameshot/issues/3365#issuecomment-1868580715
    dconf.settings = {
      # Disables the default screenshot interface
      "org/gnome/shell/keybindings" = {
        show-screenshot-ui = [];
      };
      # Sets the new keybindings
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
      };
      # Defines the new shortcut
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "Print";
        command = let
          flameshot-gui = pkgs.writeShellScriptBin "flameshot-gui" "${pkgs.flameshot}/bin/flameshot gui";
        in "${flameshot-gui}/bin/flameshot-gui";
        name = "Flameshot";
      };
    };
  };
}
