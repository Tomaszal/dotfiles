{den, ...}: {
  den.default = {
    includes = [(den.batteries.user-shell "fish")];

    homeManager = {pkgs, ...}: {
      programs.fzf.enable = true;
      programs.fd.enable = true;
      programs.bat.enable = true;

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
