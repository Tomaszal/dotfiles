{pkgs, ...}: {
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  hm.programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    historySubstringSearch.enable = true;
  };
}
