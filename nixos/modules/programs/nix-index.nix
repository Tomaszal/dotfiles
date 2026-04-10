{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nix-index-database.nixosModules.default];
  hm.imports = [inputs.nix-index-database.homeModules.default];

  environment.systemPackages = with pkgs; [comma];
}
