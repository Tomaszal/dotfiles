{den, ...}: {
  den.aspects.dev.postman = {
    includes = [(den.batteries.unfree ["postman"])];

    homeManager = {pkgs-unstable, ...}: {
      home.packages = with pkgs-unstable; [postman];
    };
  };
}
