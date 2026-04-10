{
  # Fix MX Master 3 scroll wheel
  # https://wiki.archlinux.org/title/Logitech_MX_Master#Hi-resolution_scrolling
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Logitech MX Master 3]
    MatchVendor=0x46D
    MatchProduct=0x4082
    AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
  '';
}
