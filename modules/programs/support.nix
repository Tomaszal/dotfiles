{den, ...}: {
  den.aspects.support.teamviewer = {
    includes = [(den.batteries.unfree ["teamviewer"])];

    nixos.services.teamviewer.enable = true;
  };
}
