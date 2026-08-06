{
  den.aspects.dev.homeManager = {pkgs, ...}: {
    programs.gh.enable = true;

    programs.mcp = {
      servers.github = {
        url = "https://api.githubcopilot.com/mcp/";
        enabled = true;
        oauth = false;
        headers.Authorization = "Bearer {env:GITHUB_PERSONAL_ACCESS_TOKEN}";
      };

      wrapperHooks = ''
        GITHUB_PERSONAL_ACCESS_TOKEN="$(${pkgs.gh}/bin/gh auth token)"
        export GITHUB_PERSONAL_ACCESS_TOKEN
      '';
    };
  };
}
