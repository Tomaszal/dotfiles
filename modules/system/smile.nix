{lib, ...}: {
  den.default.homeManager = {pkgs, ...}: {
    programs.gnome-shell.extensions = [
      {package = pkgs.gnomeExtensions.smile-complementary-extension;}
    ];

    custom-keybindings.smile = {
      command = lib.getExe pkgs.smile;
      binding = "<Super>period";
    };
  };
}
