{den, ...}: {
  den.aspects.dev.postman = {
    includes = [(den.batteries.unfree ["postman"])];

    homeManager = {pkgs-mv, ...}: {
      home.packages = with pkgs-mv.tip; [postman];
    };
  };
}
