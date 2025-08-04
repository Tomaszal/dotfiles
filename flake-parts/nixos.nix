{
  inputs,
  self,
  ...
}: let
  nixos = args:
    inputs.nixpkgs-stable.lib.nixosSystem (
      {specialArgs = {inherit self inputs;};}
      // args
    );
in {
  flake.nixosConfigurations = {
    pc = nixos {modules = [../nixos/configurations/pc];};
  };

  perSystem = {system, ...}: {
    packages.installer =
      (nixos {
        inherit system;
        modules = [../nixos/configurations/installer];
      }).config.system.build.isoImage;

    # packages.installer = let
    #   nixos = inputs.nixpkgs.lib.nixosSystem {
    #     inherit system;
    #     specialArgs = {inherit self;};
    #     modules = [../nixos/configurations/installer];
    #   };
    # in
    #   nixos.config.system.build.isoImage;
  };
}
