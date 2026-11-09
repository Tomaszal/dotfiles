{
  den.aspects.system.tailscale = {
    nixos = {user, ...}: {
      services.tailscale = {
        enable = true;
        openFirewall = true;
        extraSetFlags = ["--operator=${user.userName}"];
      };
    };

    homeManager.services.tailscale-systray.enable = true;
  };
}
