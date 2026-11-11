{
  den.default.homeManager = {mv, ...}: {
    home.packages = with mv.fast.latest; [libreoffice];
  };
}
