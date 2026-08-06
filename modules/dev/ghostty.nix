{
  # https://github.com/ghostty-org/ghostty/discussions/11648
  # https://github.com/ghostty-org/ghostty/pull/12483
  flake-file.inputs.ghostty = {
    url = "github:ghostty-org/ghostty";
    inputs = {
      flake-compat.follows = "flake-compat";
      home-manager.follows = "home-manager";
      nixpkgs.follows = "nixpkgs-unstable";
      systems.follows = "systems";
    };
  };

  den.aspects.dev.homeManager = {
    inputs',
    lib,
    ...
  }: let
    ghostty = inputs'.ghostty.packages.ghostty;
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
