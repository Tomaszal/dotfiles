{
  inputs,
  den,
  ...
}: {
  flake-file.inputs.den.url = "github:denful/den/latest";

  imports = [inputs.den.flakeModules.dendritic];

  den.default.includes = with den.batteries; [
    inputs'
    self'
  ];
}
