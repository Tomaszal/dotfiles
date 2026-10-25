import * as Main from "resource:///org/gnome/shell/ui/main.js";

const offset = (value) => (value < 0 ? "" : "+") + value;

const geometry = (rect, monitor) => {
  // GNOME and Flameshot coordinates are assumed to use the same scale. The
  // current setup does not use fractional or mixed monitor scaling.
  return `${rect.width}x${rect.height}${offset(rect.x - monitor.x)}${offset(rect.y - monitor.y)}`;
};

// GNOME logical-monitor indices and Qt's Wayland output order are independent.
// Match geometry against QGuiApplication::screens(), the list Flameshot indexes.
const screen = (monitor, screens) => {
  const index = screens.findIndex((candidate) =>
    ["x", "y", "width", "height"].every((key) => candidate[key] === monitor[key]),
  );
  if (index === -1) throw new Error("Target monitor not found in Qt screens");
  return index;
};

export default function target(args) {
  switch (args.mode) {
    case "number":
      return { screen: screen(Main.layoutManager.currentMonitor, args.screens) };
    case "screen":
      return {
        screen: screen(Main.layoutManager.currentMonitor, args.screens),
        region: geometry(Main.layoutManager.currentMonitor, Main.layoutManager.currentMonitor),
      };
    case "window": {
      const window = global.display.focus_window;
      if (window === null) return null;

      const monitor = Main.layoutManager.monitors[window.get_monitor()];
      return {
        screen: screen(monitor, args.screens),
        region: geometry(window.get_frame_rect(), monitor),
      };
    }
    default:
      throw new Error(`Unknown capture mode: ${args.mode}`);
  }
}
