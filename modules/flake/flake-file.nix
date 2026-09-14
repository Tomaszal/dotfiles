{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.flake-file.flakeModules.dendritic];

  flake-file.formatter = pkgs: pkgs.alejandra;

  flake-file.nixConfig = {
    extra-substituters = lib.mkBefore ["https://nix-community.cachix.org"];
    extra-trusted-public-keys = lib.mkBefore ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
  };
}
