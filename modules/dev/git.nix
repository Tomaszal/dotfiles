{
  den.default.homeManager = {
    pkgs,
    mv,
    ...
  }: {
    programs.git = {
      enable = true;
      package = mv.fast.latest.git;
      settings = {
        rerere.enabled = true;
        git-town = {
          proposal-breadcrumb = "none";
          sync-tags = false;
          push-branches = false;
          push-hook = true;
        };
      };
    };

    programs.lazygit = {
      enable = true;
      package = mv.fast.latest.lazygit;
      settings.git.pagers = [
        {pager = "delta --paging=never";}
        {externalDiffCommand = "difft --color=always";}
      ];
    };

    home.packages = let
      # https://stackoverflow.com/a/47939403
      git-sweep = pkgs.writeShellApplication {
        name = "git-sweep";

        runtimeInputs = with mv.fast.latest; [git];

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
      mv.fast.latest.delta
      mv.fast.latest.difftastic
      mv.fast.latest.git-town
    ];
  };
}
