{
  den.aspects.pc.nixos = {
    pkgs,
    mv,
    ...
  }: {
    # Generate boot entries for dual booting other OS's
    boot.loader.grub.useOSProber = true;

    # NTFS support
    boot.supportedFilesystems = ["ntfs"];

    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "reboot-to-windows";
        runtimeInputs =
          (with mv.fast.latest; [coreutils gnugrep])
          ++ [pkgs.grub2];
        # https://unix.stackexchange.com/a/112284
        text = ''
          if [ "$EUID" -ne 0 ]; then
            echo "Permission denied"
            exit
          fi

          WINDOWS_TITLE=$( \
            grep -i "^menuentry 'Windows" /boot/grub/grub.cfg \
            | head -n 1 \
            | cut -d"'" -f2 \
          )

          grub-reboot "$WINDOWS_TITLE"
          systemctl reboot
        '';
      })
    ];
  };
}
