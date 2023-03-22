# TODO: refactor if issue is resolved
# https://github.com/nix-community/disko/issues/184
{
  root = {
    label = "root";
    mountpoint = "/";
  };
  boot = {
    label = "ESP";
    mountpoint = "/boot";
  };
  swap = {
    label = "swap";
  };
}
