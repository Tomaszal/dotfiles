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
    laptop = nixos {modules = [../nixos/configurations/laptop];};
    pc = nixos {modules = [../nixos/configurations/pc];};
  };

  perSystem = {system, ...}: {
    packages.installer =
      (nixos {
        inherit system;
        modules = [../nixos/configurations/installer];
      }).config.system.build.isoImage;
  };
}
