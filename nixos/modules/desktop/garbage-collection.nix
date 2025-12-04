let
  gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
in {
  nix.gc = gc;
  hm.nix.gc = gc;
}
