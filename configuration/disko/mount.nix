{self, ...}: {
  imports = [
    self.inputs.disko.nixosModules.disko
    ./config.nix
  ];
}
