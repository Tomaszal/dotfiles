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
          "${./hardware}/${name}.nix"

          ./direnv.nix
          ./disko/mount.nix
          ./flatpak
          ./git.nix
          ./gpg.nix
          ./grub.nix
          ./hyprland.nix
          ./kernel.nix
          ./locale.nix
          ./nix.nix
          ./options.nix
          ./pipewire.nix
          ./piv-agent.nix
          ./plymouth.nix
          ./sddm.nix
          ./state-version.nix
          ./user.nix
          ./wayland.nix
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
