{self, ...}: {
  system.autoUpgrade = {
    enable = true;
    flake = self.outPath;
    flags = [
      "--recreate-lock-file"
      "--no-write-lock-file"
      "--print-build-logs"
    ];
  };
}
