{
  inputs,
  den,
  ...
}: {
  flake-file.inputs.den.url = "github:denful/den/latest";

  imports = [inputs.den.flakeModules.dendritic];

  # Use selective schemas instead of Den's recommended full strict module:
  # strict aspects currently reject valid class keys. Keep these checks until
  # upstream resolves https://github.com/denful/den/issues/632.
  den.schema = {
    host = den.lib.strict;
    user = den.lib.strict;
    home = den.lib.strict;
  };

  den.default.includes = with den.batteries; [
    inputs'
    self'
  ];
}
