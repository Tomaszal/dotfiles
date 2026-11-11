{lib, ...}: {
  den.default.homeManager = {
    pkgs,
    mv,
    ...
  }: {
    programs.gnome-shell.extensions = [
      {package = pkgs.gnomeExtensions.smile-complementary-extension;}
    ];

    custom-keybindings.smile = {
      command = lib.getExe' mv.fast.latest.smile "smile";
      binding = "<Super>period";
    };
  };
}
