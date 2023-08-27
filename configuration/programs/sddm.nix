{pkgs, ...}: {
  services.xserver = {
    enable = true;
    displayManager = {
      sddm = {
        enable = true;
        theme = "breeze";
      };
    };
  };

  # Dependencies for SDDM Breeze theme
  environment.systemPackages = with pkgs.libsForQt5; [
    kdeclarative
    kirigami2
    plasma-framework
    plasma-workspace
  ];

  # TODO: remove when fixed upstream
  # https://github.com/NixOS/nixpkgs/blob/b85ed9dcbf187b909ef7964774f8847d554fab3b/nixos/modules/services/x11/desktop-managers/plasma5.nix#L313
  environment.pathsToLink = ["/share"];
}
