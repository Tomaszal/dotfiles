{
  den.aspects.dev.opencode.homeManager = {pkgs-unstable, ...}: {
    programs.opencode = {
      enable = true;
      package = with pkgs-unstable; opencode;
    };
  };
}
