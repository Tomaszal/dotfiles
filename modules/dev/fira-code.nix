{
  den.default = {
    nixos = {pkgs, ...}: {
      fonts.packages = with pkgs; [nerd-fonts.fira-code];
    };

    homeManager.dconf.settings."org/gnome/desktop/interface".monospace-font-name = "FiraCode Nerd Font 11";
  };
}
