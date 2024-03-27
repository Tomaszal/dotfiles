let
  gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 7d";
  };
in {
  nix.gc = {
    inherit (gc) automatic options;
    dates = gc.frequency;
  };

  # TODO: enable home manager garbage collection after upgrading to 24.05
  # hm.nix.gc = {
  #   inherit (gc) automatic frequency options;
  # };
}
