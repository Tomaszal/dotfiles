{pkgs, ...}: {
  hm.services.flameshot.enable = true;

  # https://github.com/flameshot-org/flameshot/issues/3365#issuecomment-1868580715
  hm.dconf.settings = {
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
}
