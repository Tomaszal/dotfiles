{
  self,
  lib,
  ...
}: {
  # Sync NixOS configuration revision to the Flake's Git revision
  system.configurationRevision = lib.mkIf (self ? rev) self.rev;
}
