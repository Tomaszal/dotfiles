{lib, ...}: {
  perSystem = {pkgs, ...}: {
    packages.middle-button-scroll = pkgs.writeShellApplication {
      name = "middle-button-scroll";
      text = ''exec python3 ${./script.py} "$@"'';
      runtimeInputs = [
        (pkgs.python312.withPackages (pythonPackages: [
          pythonPackages.evdev
        ]))
      ];
    };
  };

  den.default.nixos = {
    config,
    self',
    ...
  }: let
    config' = config.services.middle-button-scroll;
  in {
    options.services.middle-button-scroll = {
      enable = lib.mkEnableOption "middle-button scrolling";

      device = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Input device selector to grab for middle-button scrolling. Supports path, name:, uniq:, phys:, and path: selectors.";
      };

      threshold = lib.mkOption {
        type = lib.types.ints.positive;
        default = 8;
        description = "Movement threshold before middle-hold becomes scroll.";
      };

      sensitivity = lib.mkOption {
        type = lib.types.float;
        default = 1.0;
        description = "Scroll multiplier applied to mouse movement.";
      };
    };

    config = lib.mkIf config'.enable {
      assertions = [
        {
          assertion = config'.device != null;
          message = "services.middle-button-scroll.device must be set when middle-button-scroll is enabled.";
        }
      ];

      boot.kernelModules = ["uinput"];

      systemd.services.middle-button-scroll = {
        description = "Convert held middle mouse button movement into scroll events";
        wantedBy = ["graphical.target"];
        after = ["systemd-udev-settle.service"];

        serviceConfig = {
          ExecStart = lib.escapeShellArgs [
            (lib.getExe self'.packages.middle-button-scroll)
            "--threshold"
            (toString config'.threshold)
            "--sensitivity"
            (toString config'.sensitivity)
            "--device"
            config'.device
          ];
          Restart = "always";
          RestartSec = "1s";
        };
      };
    };
  };
}
