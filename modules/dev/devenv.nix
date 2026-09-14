{lib, ...}: {
  # TODO: replace with built-in option once merged upstream
  # https://github.com/nix-community/home-manager/pull/9379
  den.aspects.dev.homeManager = {pkgs-mv, ...}: let
    package = with pkgs-mv.tip; devenv;
  in {
    home.packages = [package];

    programs.fish.interactiveShellInit = lib.mkAfter ''
      set --export DEVENV_SHELL_TYPE fish
      ${lib.getExe package} hook fish | source
    '';
  };
}
