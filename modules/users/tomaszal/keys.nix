{inputs, ...}: {
  flake-file.inputs.keys = {
    url = "github:tomaszal/keys";
    inputs.flake-parts.follows = "flake-parts";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.tomaszal.homeManager.programs = {
    git.signing.key = toString inputs.keys.ssh.yubikey.piv-agent.touch-policy.never;

    gpg.publicKeys = [
      {
        source = inputs.keys.pgp.yubikey.piv-agent;
        trust = "ultimate";
      }
      {
        source = inputs.keys.pgp.fallback;
        trust = "full";
      }
    ];
  };
}
