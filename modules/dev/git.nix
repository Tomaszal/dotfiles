{
  den.default.homeManager = {
    inputs',
    pkgs,
    ...
  }: {
    programs.git.enable = true;

    home.packages = let
      # https://stackoverflow.com/a/47939403
      git-sweep = pkgs.writeShellApplication {
        name = "git-sweep";

        runtimeInputs = with pkgs; [git];

        text = ''
          git fetch --prune

          for branch in $(\
            git for-each-ref --omit-empty --format \
              '%(if:equals=gone)%(upstream:track,nobracket)%(then)%(refname:short)%(end)' \
              refs/heads/ \
          ); do
            git branch --delete "$branch" || continue
          done
        '';
      };
    in [
      git-sweep
      inputs'.llm-agents.packages.but
      inputs'.llm-agents.packages.gitbutler
    ];
  };
}
