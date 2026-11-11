{den, ...}: {
  den.aspects.dev.postman = {
    includes = [(den.batteries.unfree ["postman"])];

    homeManager = {mv, ...}: {
      home.packages = with mv.tip; [postman];
    };
  };
}
