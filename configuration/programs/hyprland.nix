{
  self,
  pkgs,
  ...
}: {
  # Essential desktop software
  environment.systemPackages = with pkgs; [
    # Taskbar
    waybar

    # Notifications
    mako
    libnotify

    # Launcher
    rofi-wayland

    # Media control utility
    playerctl
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;

    # Use the package from the flake for the latest Hyprland version
    package = self.inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  hm = {
    # Use the module from the flake for the latest Hyprland version
    imports = [self.inputs.hyprland.homeManagerModules.default];

    # Enable media control daemon
    services.playerctld.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        monitor = , 1920x1080, auto, 1

        input {
          kb_layout = us,ru
        }

        dwindle {
          no_gaps_when_only = true
        }

        exec-once = waybar
        exec-once = mako

        # Authentication agent
        exec-once = ${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1

        $mod = SUPER

        # Switch keyboard layout
        bind = CTRL + ALT, K, exec, hyprctl switchxkblayout at-translated-set-2-keyboard next

        # Volume controls
        bindel = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        bindel = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
        bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

        # Media controls
        bindl = , XF86AudioPlay, exec, playerctl play-pause
        bindl = , XF86AudioStop, exec, playerctl stop
        bindl = , XF86AudioPrev, exec, playerctl previous
        bindl = , XF86AudioNext, exec, playerctl next

        # Launch apps
        bind = $mod, return, exec, konsole
        bind = $mod, space, exec, rofi -show drun -show-icons

        # General keybinds
        bind = $mod, W, killactive,

        # Group controls
        bind = $mod, G, togglegroup,
        bind = ALT, tab, changegroupactive, f
        bind = ALT + SHIFT, tab, changegroupactive, b

        # Window controls
        bind = $mod, home, fullscreen, 1
        bind = $mod, end, togglefloating,

        # Move/resize windows with $mod + LMB/RMB + drag
        bindm = $mod, mouse:272, movewindow
        bindm = $mod, mouse:273, resizewindow

        # Move window controls
        bind = $mod + SHIFT, up, movewindow, u
        bind = $mod + SHIFT, down, movewindow, d
        bind = $mod + SHIFT, left, movewindow, l
        bind = $mod + SHIFT, right, movewindow, r

        # Focus controls
        bind = $mod, up, movefocus, u
        bind = $mod, down, movefocus, d
        bind = $mod, left, movefocus, l
        bind = $mod, right, movefocus, r

        # Move between workspaces
        bind = $mod, tab, workspace, e+1
        bind = $mod + SHIFT, tab, workspace, e-1
        bind = $mod, grave, workspace, previous

        # Switch/move window to workspace by ID
        ${
          builtins.concatStringsSep "\n" (
            builtins.genList (
              index: let
                workspaceId = toString (index + 1);
              in ''
                bind = $mod, ${workspaceId}, workspace, ${workspaceId}
                bind = $mod + SHIFT, ${workspaceId}, movetoworkspace, ${workspaceId}
              ''
            )
            9
          )
        }
      '';
    };
  };
}
