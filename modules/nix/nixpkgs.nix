{inputs, ...}: {
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  den.default = {
    nixos = {pkgs, ...}: {
      _module.args.pkgs-unstable = import inputs.nixpkgs-unstable pkgs;
    };

    homeManager = {pkgs, ...}: {
      _module.args.pkgs-unstable = import inputs.nixpkgs-unstable pkgs;
    };
  };
}
