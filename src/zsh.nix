{pkgs, ...}: {
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  hm.programs.zsh = {
    enable = true;
    # TODO: fix deprecation after upgrading to 24.05
    # autosuggestion.enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
  };
}
