{
  den.aspects.dev.homeManager = {
    pkgs,
    lib,
    ...
  }: let
    inherit (pkgs) ghostty;
  in {
    programs.ghostty = {
      enable = true;
      package = ghostty;
      settings = {
        theme = "Abernathy";
        font-family = "FiraCode Nerd Font";
        font-size = 11;
      };
    };

    custom-keybindings.ghostty = {
      command = lib.getExe ghostty;
      binding = "<Super>Return";
    };
  };
}
