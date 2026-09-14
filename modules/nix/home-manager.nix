{config, ...}: {
  flake-file.inputs.home-manager = {
    url = "github:nix-community/home-manager/release-${config.nixos-release}";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.schema.user.classes = ["homeManager"];

  # Host-scoped Home Manager settings must go through `hm-host`, which is only
  # applied to hosts that actually have Home Manager users.
  den.schema.hm-host.includes = [
    {
      nixos = {
        pkgs-unstable,
        sources,
        ...
      }: {
        home-manager = {
          extraSpecialArgs = {inherit pkgs-unstable sources;};
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      };
    }
  ];
}
