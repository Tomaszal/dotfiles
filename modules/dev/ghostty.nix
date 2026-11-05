{
  den.aspects.dev.homeManager = {
    pkgs-mv,
    lib,
    ...
  }: let
    package = pkgs-mv.tip.ghostty;
  in {
    programs.ghostty = {
      inherit package;
      enable = true;
      settings = {
        theme = "Abernathy";
        font-family = "FiraCode Nerd Font";
        font-size = 11;
      };
    };

    custom-keybindings.ghostty = {
      command = lib.getExe package;
      binding = "<Super>Return";
    };
  };
}
