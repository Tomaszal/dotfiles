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
          {networking.hostName = name;}
          "${./hardware}/${name}.nix"

          ./auto-upgrade.nix
          ./direnv.nix
          ./disko/mount.nix
          ./docker.nix
          ./flatpak
          ./git.nix
          ./gnome.nix
          ./gpg.nix
          ./grub.nix
          ./kernel.nix
          ./locale.nix
          ./nix.nix
          ./pipewire.nix
          ./piv-agent.nix
          ./plymouth.nix
          ./state-version.nix
          ./udisks.nix
          ./user.nix
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
