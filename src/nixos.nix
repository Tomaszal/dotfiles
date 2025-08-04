{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.pc = inputs.nixpkgs-stable.lib.nixosSystem {
    specialArgs = {inherit self inputs;};
    modules = [
      {networking.hostName = "pc";}
      ./auto-upgrade.nix
      ./ddc.nix
      ./direnv.nix
      ./disko/mount.nix
      ./docker.nix
      ./flameshot.nix
      ./flatpak.nix
      ./garbage-collection.nix
      ./git.nix
      ./gnome.nix
      ./gpg.nix
      ./grub.nix
      ./hardware/pc-main-amd64.nix
      ./kernel.nix
      ./locale.nix
      ./nix.nix
      ./pipewire.nix
      ./piv-agent.nix
      ./plymouth.nix
      ./reboot-to-windows.nix
      ./state-version.nix
      ./udisks.nix
      ./user.nix
      ./vscode.nix
      ./zsh.nix
    ];
  };

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
