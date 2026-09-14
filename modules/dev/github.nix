{
  den.aspects.dev.homeManager = {
    pkgs-unstable,
    lib,
    ...
  }: let
    package = with pkgs-unstable; gh;
  in {
    programs.gh = {
      inherit package;
      enable = true;
      extensions = with pkgs-unstable; [gh-stack];
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
