{
  den.aspects.games.minecraft.homeManager = {pkgs-mv, ...}: {
    programs.prismlauncher = {
      enable = true;
      package = with pkgs-mv.tip; prismlauncher;
    };
  };
}
