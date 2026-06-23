{
  den.aspects.dev.docker.nixos = {user, ...}: {
    virtualisation.docker.enable = true;

    # Allow main user to run docker without sudo
    users.groups.docker.members = [user.userName];

    # https://github.com/NixOS/nixpkgs/issues/417641
    networking.firewall.trustedInterfaces = ["br+"];
  };
}
