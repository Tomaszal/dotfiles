{
  inputs,
  pkgs,
  ...
}: {
  # Setup unstable nixpkgs with stable nixpkgs settings
  _module.args.pkgs-unstable = import inputs.nixpkgs pkgs;
}
