{den, ...}: {
  den.default = {
    includes = [(den.batteries.user-shell "zsh")];

    homeManager.programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
    };
  };
}
