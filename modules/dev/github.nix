{
  den.aspects.dev.homeManager = {
    lib,
    pkgs-mv,
    ...
  }: let
    package = with pkgs-mv.tip; gh;
  in {
    programs.gh = {
      inherit package;
      enable = true;
      extensions = with pkgs-mv.tip; [gh-stack];
    };

    programs.mcp = {
      servers.github = {
        url = "https://api.githubcopilot.com/mcp/";
        enabled = true;
        oauth = false;
        headers.Authorization = "Bearer {env:GITHUB_PERSONAL_ACCESS_TOKEN}";
      };

      wrapperHooks = ''
        GITHUB_PERSONAL_ACCESS_TOKEN="$(${lib.getExe package} auth token)"
        export GITHUB_PERSONAL_ACCESS_TOKEN
      '';
    };
  };
}
