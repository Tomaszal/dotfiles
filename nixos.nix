{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    nixosForHardware = name:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self;};
        modules = [
          {networking.hostName = "tomaszal-nixos-${name}";}
          "${./hardware-configuration}/${name}.nix"
          ./configuration
        ];
      };
  in
    builtins.listToAttrs (map (filename: rec {
      name = builtins.substring 0 (builtins.stringLength filename - 4) filename;
      value = nixosForHardware name;
    }) (builtins.attrNames (builtins.readDir ./hardware-configuration)));

  perSystem = {system, ...}: {
    packages.installer = let
      nixos = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit self;};
        modules = [./configuration/installer];
      };
    in
      nixos.config.system.build.isoImage;
  };
}
