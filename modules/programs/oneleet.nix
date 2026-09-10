{den, ...}: {
  den.aspects.programs.oneleet = {
    includes = [(den.batteries.unfree ["oneleet-agent"])];

    nixos = {
      lib,
      pkgs,
      ...
    }: let
      oneleet = pkgs.stdenvNoCC.mkDerivation rec {
        pname = "oneleet-agent";
        version = "2.3.5";

        src = pkgs.fetchurl {
          url = "https://downloads.oneleet.com/agent/linux/Oneleet_${version}_amd64.deb";
          hash = "sha256-u9r2arf0HKXKpoj+CFmNwELGN8uwhfGHhXpEsSzJoPw=";
        };

        nativeBuildInputs = [pkgs.dpkg];

        unpackPhase = ''
          runHook preUnpack
          dpkg-deb --fsys-tarfile "$src" \
            | tar --extract --file=- --no-same-owner --no-same-permissions
          runHook postUnpack
        '';

        installPhase = ''
          runHook preInstall

          install -dm755 "$out/libexec/oneleet"
          cp -a opt/Oneleet/. "$out/libexec/oneleet/"

          install -Dm644 usr/share/applications/oneleet-agent.desktop \
            "$out/share/applications/oneleet-agent.desktop"
          substituteInPlace "$out/share/applications/oneleet-agent.desktop" \
            --replace-fail "Exec=/opt/Oneleet/oneleet-agent" "Exec=oneleet-agent"
          install -Dm644 usr/share/icons/hicolor/256x256/apps/oneleet-agent.png \
            "$out/share/icons/hicolor/256x256/apps/oneleet-agent.png"

          install -dm755 "$out/bin"
          ln -s /opt/Oneleet/oneleet-agent "$out/bin/oneleet-agent"
          ln -s /opt/Oneleet/oneleet-daemon "$out/bin/oneleet-cli"

          runHook postInstall
        '';

        meta = {
          description = "Oneleet compliance agent";
          homepage = "https://www.oneleet.com";
          license = lib.licenses.unfree;
          mainProgram = "oneleet-agent";
          platforms = ["x86_64-linux"];
          sourceProvenance = [lib.sourceTypes.binaryNativeCode];
        };
      };

      # Oneleet does not recognize NixOS's generated iptables chain layout.
      # Expose the real NixOS firewall service state in the UFW format it parses.
      nixosFirewallStatus = pkgs.writeShellScriptBin "ufw" ''
        if [[ "$1" != "status" ]]; then
          echo "Only firewall status checks are supported" >&2
          exit 64
        fi

        if systemctl is-active --quiet firewall.service; then
          echo "Status: active"
        else
          echo "Status: inactive"
        fi
      '';
    in {
      environment.systemPackages = [oneleet];

      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          alsa-lib
          at-spi2-core
          cairo
          cups
          dbus
          expat
          glib
          gtk3
          libgbm
          libnotify
          libsecret
          libx11
          libxcomposite
          libxdamage
          libxext
          libxfixes
          libxkbcommon
          libxrandr
          libxscrnsaver
          libxtst
          libxcb
          nspr
          nss
          pango
          stdenv.cc.cc
          systemd
          util-linux
        ];
      };

      # Seed the mutable vendor-managed installation once. Oneleet's updater
      # subsequently owns this directory, while NixOS owns the service unit.
      systemd.tmpfiles.rules = [
        "d /opt 0755 root root -"
        "C /opt/Oneleet 0755 root root - ${oneleet}/libexec/oneleet"
        "d /var/log/oneleet 0755 root root -"
        "d /var/opt/Oneleet 0755 root root -"
      ];

      systemd.services.oneleet-daemon = {
        description = "Oneleet compliance agent";
        wantedBy = ["multi-user.target"];
        wants = ["network-online.target"];
        after = [
          "network-online.target"
          "systemd-tmpfiles-setup.service"
        ];

        path = with pkgs; [
          nixosFirewallStatus
          coreutils
          iptables
          nftables
          shadow
          systemd
          util-linux
        ];

        serviceConfig = {
          ExecStart = "/opt/Oneleet/oneleet-daemon";
          Restart = "always";
          RestartSec = "120s";
          WorkingDirectory = "/opt/Oneleet";
        };
      };
    };
  };
}
