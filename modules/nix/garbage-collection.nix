let
  gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
in {
  den.default = {
    nixos.nix.gc = gc;
    homeManager.nix.gc = gc;
  };
}
