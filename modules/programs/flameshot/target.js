import * as Main from "resource:///org/gnome/shell/ui/main.js";

const geometry = (rect, monitor) => {
  const offset = (value) => (value < 0 ? "" : "+") + value;

  // GNOME and Flameshot coordinates are assumed to use the same scale. The
  // current setup does not use fractional or mixed monitor scaling.
  return (
    `${rect.width}x${rect.height}` +
    `${offset(rect.x - monitor.x)}${offset(rect.y - monitor.y)}`
  );
};

// In this setup, Qt/Flameshot enumerates monitors in reverse GNOME order.
const screen = (index) => Main.layoutManager.monitors.length - 1 - index;

export default async function target(args) {
  switch (args.mode) {
    case "number":
      return { screen: screen(Main.layoutManager.currentMonitor.index) };
    case "screen":
      return {
        screen: screen(Main.layoutManager.currentMonitor.index),
        region: geometry(
          Main.layoutManager.currentMonitor,
          Main.layoutManager.currentMonitor,
        ),
      };
    case "window": {
      const window = global.display.focus_window;
      if (window === null) return null;

      const monitor = Main.layoutManager.monitors[window.get_monitor()];
      return {
        screen: screen(monitor.index),
        region: geometry(window.get_frame_rect(), monitor),
      };
    }
    default:
      throw new Error(`Unknown capture mode: ${args.mode}`);
  }
}
