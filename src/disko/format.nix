{
  pkgs,
  self,
  ...
}: let
  inherit (self.inputs) disko;
  inherit (pkgs) system;
  wrapper = pkgs.writeShellApplication {
    name = "disko";
    runtimeInputs = [disko.packages.${system}.disko];
    text = ''
      disko "$@" ${./.}/config.nix
    '';
  };
in {
  environment.systemPackages = [wrapper];
}
