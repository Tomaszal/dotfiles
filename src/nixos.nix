{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    nixosForHardware = name:
      inputs.nixpkgs-stable.lib.nixosSystem {
        specialArgs = {inherit self;};
        modules = [
          {networking.hostName = name;}
          "${./hardware}/${name}.nix"

          ./auto-upgrade.nix
          ./ddc.nix
          ./direnv.nix
          ./disko/mount.nix
          ./docker.nix
          ./flatpak
          ./garbage-collection.nix
          ./git.nix
          ./gnome.nix
          ./gpg.nix
          ./grub.nix
          ./kernel.nix
          ./locale.nix
          ./nix.nix
          ./pipewire.nix
          ./plymouth.nix
          ./state-version.nix
          ./udisks.nix
          ./user.nix
          ./vscode.nix
          ./zsh.nix
        ];
      };
  in
    builtins.listToAttrs (map (filename: rec {
      name = builtins.substring 0 (builtins.stringLength filename - 4) filename;
      value = nixosForHardware name;
    }) (builtins.attrNames (builtins.readDir ./hardware)));

  perSystem = {system, ...}: {
    packages.installer = let
      nixos = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit self;};
        modules = [./installer];
      };
    in
      nixos.config.system.build.isoImage;
  };
}
