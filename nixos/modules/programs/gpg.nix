{inputs, ...}: {
  hm.programs.gpg = {
    enable = true;
    publicKeys = [
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
