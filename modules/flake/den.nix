{inputs, ...}: {
  flake-file.inputs.den.url = "github:vic/den/latest";

  imports = [inputs.den.flakeModules.dendritic];
}
