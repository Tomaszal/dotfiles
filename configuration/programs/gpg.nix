{
  hm.programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = ../../keys/tomaszal-piv-agent.asc;
        trust = "ultimate";
      }
      {
        source = ../../keys/tomaszal-fallback.asc;
        trust = "full";
      }
    ];
  };
}
