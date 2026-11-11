{den, ...}: {
  den.schema.user.includes = [(den.batteries.user-shell "fish")];

  den.default = {
    homeManager = {
      pkgs,
      mv,
      ...
    }: {
      programs.fzf = {
        enable = true;
        package = mv.fast.latest.fzf.eval;
      };
      programs.fd = {
        enable = true;
        package = mv.fast.latest.fd;
      };
      programs.bat = {
        enable = true;
        package = mv.fast.latest.bat.eval;
      };

      programs.fish = {
        interactiveShellInit = ''
          set fish_greeting # Disable greeting
        '';

        plugins = let
          plugins = with pkgs.fishPlugins; [
            autopair
            colored-man-pages
            fzf-fish
            z
          ];
        in
          map (plugin: {
            name = plugin.pname;
            src = plugin.src;
          })
          plugins;
      };
    };
  };
}
