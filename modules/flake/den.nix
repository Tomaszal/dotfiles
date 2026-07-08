{
  inputs,
  den,
  ...
}: {
  flake-file.inputs.den.url = "github:vic/den/latest";

  imports = [inputs.den.flakeModules.dendritic];

  den.default.includes = with den.batteries; [
    inputs'
    self'
  ];
}
