let
  gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };
in {
  nix.gc = {
    inherit (gc) automatic options;
    dates = gc.frequency;
  };

  hm.nix.gc = {
    inherit (gc) automatic frequency options;
  };
}
