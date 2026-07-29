import argparse
from pathlib import Path
import select
import sys
import time

from evdev import InputDevice, UInput, ecodes, list_devices  # type: ignore

VIRTUAL_PREFIX = "middle-button-scroll virtual"


def is_mouse(device):
  if device.name.lower().startswith(VIRTUAL_PREFIX):
    return False

  caps = device.capabilities(absinfo=False)
  rel = set(caps.get(ecodes.EV_REL, []))
  keys = set(caps.get(ecodes.EV_KEY, []))

  return ecodes.REL_X in rel and ecodes.REL_Y in rel and ecodes.BTN_MIDDLE in keys


def output_capabilities(device):
  caps = {
    event_type: list(codes)
    for event_type, codes in device.capabilities(absinfo=False).items()
    if event_type != ecodes.EV_SYN
  }

  rel = set(caps.get(ecodes.EV_REL, []))
  rel.update(
    [
      ecodes.REL_WHEEL_HI_RES,
      ecodes.REL_HWHEEL_HI_RES,
    ]
  )
  caps[ecodes.EV_REL] = sorted(rel)

  return caps


def input_device_paths():
  paths = set(list_devices())
  paths.update(str(path) for path in Path("/dev/input/by-id").glob("*") if path.exists())

  return sorted(paths)


def device_matches(device, path, selector):
  selector_type, _, selector_value = selector.partition(":")

  if selector_type == "path":
    return path == selector_value
  if selector_type == "name":
    return device.name == selector_value
  if selector_type == "uniq":
    return device.uniq == selector_value
  if selector_type == "phys":
    return device.phys == selector_value

  return selector in [path, device.name, device.uniq, device.phys]


def candidate_mice():
  candidates = []
  seen = set()
  for path in input_device_paths():
    try:
      device = InputDevice(path)
    except OSError:
      continue

    try:
      real_path = str(Path(path).resolve())
      key = (real_path, device.name, device.phys, device.uniq)
      if key not in seen and is_mouse(device):
        candidates.append(
          {
            "path": path,
            "real_path": real_path,
            "name": device.name,
            "phys": device.phys,
            "uniq": device.uniq,
          }
        )
        seen.add(key)
    finally:
      device.close()

  return candidates


def resolve_device(selector):
  matches = []
  for candidate in candidate_mice():
    try:
      device = InputDevice(candidate["path"])
    except OSError:
      continue

    try:
      if device_matches(device, candidate["path"], selector) or device_matches(
        device, candidate["real_path"], selector
      ):
        matches.append(candidate)
    finally:
      device.close()

  return matches


def open_mouse(selector, threshold, sensitivity):
  matches = resolve_device(selector)
  if len(matches) != 1:
    return None, matches

  path = matches[0]["path"]
  device = InputDevice(path)
  if not is_mouse(device):
    device.close()
    return None, []

  output = UInput(
    output_capabilities(device),
    name=f"{VIRTUAL_PREFIX} {device.name}",
    bustype=device.info.bustype,
    vendor=device.info.vendor,
    product=device.info.product,
    version=device.info.version,
  )
  device.grab()
  return (
    {
      "path": path,
      "device": device,
      "output": output,
      "pending_middle": False,
      "scrolling": False,
      "threshold": threshold,
      "sensitivity": sensitivity,
      "movement": 0,
    },
    matches,
  )


def close_mouse(mouse):
  try:
    mouse["device"].ungrab()
  except OSError:
    pass
  mouse["device"].close()
  mouse["output"].close()


def handle_event(mouse, event):
  output = mouse["output"]

  if event.type == ecodes.EV_KEY and event.code == ecodes.BTN_MIDDLE:
    if event.value:
      mouse["pending_middle"] = True
      mouse["scrolling"] = False
      mouse["movement"] = 0
      return

    if mouse["pending_middle"] and not mouse["scrolling"]:
      output.write(ecodes.EV_KEY, ecodes.BTN_MIDDLE, 1)
      output.syn()
      output.write(ecodes.EV_KEY, ecodes.BTN_MIDDLE, 0)
      output.syn()

    mouse["pending_middle"] = False
    mouse["scrolling"] = False
    mouse["movement"] = 0
    return

  if mouse["pending_middle"] and event.type == ecodes.EV_REL:
    if event.code == ecodes.REL_Y:
      mouse["movement"] += abs(event.value)
      if mouse["movement"] < mouse["threshold"]:
        return

      mouse["scrolling"] = True
      value = -event.value * mouse["sensitivity"]
      hi_res_value = round(value)
      if hi_res_value != 0:
        output.write(ecodes.EV_REL, ecodes.REL_WHEEL_HI_RES, hi_res_value)
      output.syn()
      return
    if event.code == ecodes.REL_X:
      mouse["movement"] += abs(event.value)
      if mouse["movement"] < mouse["threshold"]:
        return

      mouse["scrolling"] = True
      value = event.value * mouse["sensitivity"]
      hi_res_value = round(value)
      if hi_res_value != 0:
        output.write(ecodes.EV_REL, ecodes.REL_HWHEEL_HI_RES, hi_res_value)
      output.syn()
      return

  output.write_event(event)


def main():
  parser = argparse.ArgumentParser(prog="middle-button-scroll")
  parser.add_argument(
    "--device",
    default=None,
    help="Device selector: path, name, uniq, phys, or name:/uniq:/phys:/path: selector",
  )
  parser.add_argument(
    "--list-devices",
    action="store_true",
    help="List candidate mouse devices and exit",
  )
  parser.add_argument(
    "--threshold",
    type=int,
    default=8,
    help="Movement threshold before middle-hold becomes scroll",
  )
  parser.add_argument(
    "--sensitivity",
    type=float,
    default=1.0,
    help="Scroll multiplier applied to mouse movement",
  )
  args = parser.parse_args()

  if args.list_devices:
    for candidate in candidate_mice():
      print(
        "\t".join(
          [
            f"path:{candidate['path']}",
            f"name:{candidate['name']}",
            f"phys:{candidate['phys']}",
            f"uniq:{candidate['uniq']}",
          ]
        )
      )
    return

  if not args.device:
    print(
      "Refusing to run without an explicit device. Use --list-devices or --device /dev/input/eventX.",
      file=sys.stderr,
    )
    return 2

  mice = {}
  last_error = None

  while True:
    if not mice:
      mouse, matches = open_mouse(args.device, args.threshold, args.sensitivity)
      if mouse is None:
        if not matches:
          error = f"No supported mouse device matches selector: {args.device}"
        else:
          matching_devices = ", ".join(
            f"path:{candidate['path']} name:{candidate['name']} phys:{candidate['phys']} uniq:{candidate['uniq']}"
            for candidate in matches
          )
          error = f"Multiple mouse devices match selector: {args.device}: {matching_devices}"

        if error != last_error:
          print(error, file=sys.stderr)
          last_error = error

        time.sleep(1)
        continue

      print(f"Using mouse device: {mouse['path']}", file=sys.stderr)
      last_error = None
      mice[mouse["device"].fd] = mouse

    readable, _, _ = select.select(list(mice), [], [], 1)
    for fd in readable:
      mouse = mice.get(fd)
      if mouse is None:
        continue

      try:
        for event in mouse["device"].read():
          handle_event(mouse, event)
      except OSError:
        print(f"Mouse device disconnected: {mouse['path']}", file=sys.stderr)
        close_mouse(mouse)
        del mice[fd]


if __name__ == "__main__":
  sys.exit(main())
