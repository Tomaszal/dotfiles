{lib, ...}: {
  den.default = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.gnomeExtensions.smile-complementary-extension];
    };

    homeManager = {pkgs, ...}: {
      custom-keybindings.smile = {
        command = lib.getExe (with pkgs; smile);
        binding = "<Super>period";
      };
    };
  };
}
