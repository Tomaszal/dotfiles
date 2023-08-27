{pkgs, ...}: {
  hardware.opengl.enable = true;

  environment.systemPackages = with pkgs; [
    # QT Wayland support
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
  ];
}
