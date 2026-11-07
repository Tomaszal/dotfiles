{
  den.default.homeManager = {
    lib,
    pkgs,
    ...
  }: let
    mkD = lib.hm.gvariant.mkDouble;
    mkElement = element: visible: position: {inherit element visible position;};
    elements = [
      (mkElement "showAppsButton" true "stackedTL")
      (mkElement "centerBox" true "stackedTL")
      (mkElement "activitiesButton" false "stackedTL")
      (mkElement "taskbar" true "stackedTL")
      (mkElement "dateMenu" true "centerMonitor")
      (mkElement "leftBox" true "stackedBR")
      (mkElement "rightBox" true "stackedBR")
      (mkElement "systemMenu" true "stackedBR")
      (mkElement "desktopButton" false "stackedBR")
    ];
    dash-to-panel = pkgs.gnomeExtensions.dash-to-panel.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [./dash-to-panel-layout.patch];
      # Disable dragging maximized windows from empty panel space:
      # https://github.com/home-sweet-gnome/dash-to-panel/issues/1717
      postPatch =
        (oldAttrs.postPatch or "")
        + ''
          substituteInPlace panel.js --replace-fail \
            "if (!dragWindow) return Clutter.EVENT_PROPAGATE" \
            "return Clutter.EVENT_PROPAGATE"
        '';
    });
  in {
    programs.gnome-shell.extensions = [{package = dash-to-panel;}];

    # The patch adds shared defaults and a leftmost selector to the upstream
    # per-monitor JSON settings, without persisting detected monitor IDs.
    dconf.settings = {
      "org/gnome/shell/extensions/dash-to-panel" = {
        appicon-margin = 8;
        appicon-padding = 6;
        click-action = "CYCLE";
        dot-position = "BOTTOM";
        dot-style-focused = "DASHES";
        dot-style-unfocused = "SQUARES";
        focus-highlight = true;
        hide-overview-on-startup = true;
        hotkeys-overlay-combo = "TEMPORARILY";
        intellihide = false;
        intellihide-behaviour = "MAXIMIZED_WINDOWS";
        intellihide-hide-from-windows = true;
        intellihide-use-pressure = true;
        isolate-monitors = true;
        isolate-workspaces = true;
        leftbox-padding = 6;
        leftbox-size = 0;
        multi-monitors = true;
        panel-positions = builtins.toJSON {
          default = "RIGHT";
          leftmost = "LEFT";
        };
        panel-sizes = builtins.toJSON {default = 40;};
        panel-element-positions = builtins.toJSON {default = elements;};
        panel-element-positions-monitors-sync = true;
        scroll-panel-action = "NOTHING";
        show-apps-icon-side-padding = 8;
        status-icon-padding = 4;
        trans-dynamic-anim-target = mkD 1.0;
        trans-panel-opacity = mkD 0.4;
        trans-use-custom-opacity = true;
        trans-use-dynamic-opacity = true;
        tray-padding = -1;
        tray-size = 0;
        window-preview-title-position = "TOP";
      };
    };
  };
}
