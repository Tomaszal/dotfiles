{pkgs, ...}: {
  users.defaultUserShell = pkgs.zsh;

  hm.programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    historySubstringSearch.enable = true;
  };
}
