{self, ...}: {
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    flake = self.outPath;
    flags = [
      "--recreate-lock-file"
      "--no-write-lock-file"
      "--print-build-logs"
    ];
  };
}
