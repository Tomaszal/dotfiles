{den, ...}: {
  den.aspects.dev = {
    includes = [(den.batteries.unfree ["vscode"])];

    homeManager = {pkgs-unstable, ...}: {
      programs.vscode = {
        enable = true;
        package = pkgs-unstable.vscode;
      };

      # Might want to revert to `nano` for ssh connections
      # https://stackoverflow.com/a/57144660
      home.sessionVariables = let
        cmd = "code --wait";
      in {
        EDITOR = cmd;
        VISUAL = cmd;
      };
    };
  };
}
