{
  den.aspects.dev.homeManager = {
    mv,
    lib,
    ...
  }: let
    package = mv.fast.latest.ghostty.eval;
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
