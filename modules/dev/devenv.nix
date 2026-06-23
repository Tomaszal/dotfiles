{lib, ...}: {
  # TODO: replace with built-in option once merged upstream
  # https://github.com/nix-community/home-manager/pull/9379
  den.aspects.dev.homeManager = {pkgs-unstable, ...}: let
    package = with pkgs-unstable; devenv;
  in {
    home.packages = [package];

    programs.zsh.initContent = lib.mkAfter ''
      eval "$(${lib.getExe package} hook zsh)"
    '';
  };
}
