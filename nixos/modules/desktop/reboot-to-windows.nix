{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "reboot-to-windows";
      runtimeInputs = with pkgs; [
        coreutils
        gnugrep
        grub2
      ];
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
}
