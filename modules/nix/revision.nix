{
  self,
  lib,
  ...
}: {
  # Sync NixOS configuration revision to the Flake's Git revision
  den.default.nixos.system.configurationRevision = lib.mkIf (self ? rev) self.rev;
}
