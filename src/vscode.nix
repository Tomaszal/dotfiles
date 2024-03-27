{
  allowUnfreePackages = ["vscode"];
  hm.programs.vscode.enable = true;

  # Might want to revert to `nano` for ssh connections
  # https://stackoverflow.com/a/57144660
  hm.home.sessionVariables = let
    cmd = "code --wait";
  in {
    EDITOR = cmd;
    VISUAL = cmd;
  };
}
