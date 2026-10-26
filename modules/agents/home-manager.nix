{inputs, ...}: {
  # TODO(NixOS 26.11): Remove this helper after switching Home Manager
  # to release-26.11 with the mutable-settings helpers.
  # The newer agent modules need these helpers before they reach the release library.
  den.aspects.dev.agents.nixos = {lib, ...}: let
    hmLib = import "${inputs.home-manager}/modules/lib/stdlib-extended.nix" lib;
  in {
    home-manager.extraSpecialArgs.lib = hmLib.extend (final: previous: {
      hm =
        previous.hm
        // {
          generators =
            previous.hm.generators
            // {
              inherit
                (import "${inputs.home-manager-unstable}/modules/lib/generators.nix" {lib = final;})
                mkImpureConfigMerger
                mkImpureConfigCleanup
                ;
            };
        };
    });
  };
}
