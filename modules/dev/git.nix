{
  den.default.homeManager = {pkgs, ...}: {
    programs.git = {
      enable = true;
      settings.rerere.enabled = true;
    };

    programs.lazygit = {
      enable = true;
      settings.git.pagers = [
        {pager = "delta --paging=never";}
        {externalDiffCommand = "difft --color=always";}
      ];
    };

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
      pkgs.delta
      pkgs.difftastic
      pkgs.git-town
    ];
  };
}
