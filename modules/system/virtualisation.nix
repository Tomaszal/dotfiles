{
  den.aspects.system.virtualisation.nixos = {
    user,
    pkgs,
    ...
  }: {
    virtualisation.libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [virtiofsd];
    };

    programs.virt-manager.enable = true;

    users.users.${user.userName}.extraGroups = ["libvirtd"];

    environment.systemPackages = with pkgs; [dnsmasq];
  };
}
