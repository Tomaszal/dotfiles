{
  den.aspects.dev.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      bruno
      bruno-cli
    ];
  };
}
