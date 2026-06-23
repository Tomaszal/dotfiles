{
  den.aspects.games.minecraft.homeManager = {pkgs-unstable, ...}: {
    programs.prismlauncher = {
      enable = true;
      package = with pkgs-unstable; prismlauncher;
    };
  };
}
