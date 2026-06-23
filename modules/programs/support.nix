{den, ...}: {
  den.aspects.support.teamviewer = {
    includes = [(den.batteries.unfree ["teamviewer"])];

    homeManager.services.teamviewer.enable = true;
  };
}
