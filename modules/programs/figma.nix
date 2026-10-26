{
  den.aspects.programs.figma.homeManager = {
    pkgs,
    sources,
    ...
  }: let
    inherit (sources.figma-desktop) pname version src;

    # Upstream's AppRun imperatively copies a desktop entry into ~/.local and
    # registers the figma:// handler on every launch. Home Manager owns that.
    contents = pkgs.appimageTools.extractType2 {
      inherit pname version src;

      postExtract = ''
        substituteInPlace $out/AppRun \
          --replace-fail "integrate_desktop 2>/dev/null || true" ":"
      '';
    };

    # Icon basename must keep matching the `Icon=` key in the desktop entry.
    icon = "io.github.nickvdp.figma-desktop-linux";
  in {
    home.packages = [
      (pkgs.appimageTools.wrapAppImage {
        inherit pname version;

        src = contents;

        extraInstallCommands = ''
          install -Dm444 ${contents}/usr/share/applications/${icon}.desktop \
            $out/share/applications/${pname}.desktop
          substituteInPlace $out/share/applications/${pname}.desktop \
            --replace-fail "Exec=AppRun %u" "Exec=${pname} %u"

          install -Dm444 ${contents}/usr/share/icons/hicolor/256x256/apps/${icon}.png \
            $out/share/icons/hicolor/256x256/apps/${icon}.png
        '';
      })
    ];
  };
}
