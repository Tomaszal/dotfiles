{
  den.aspects.sweet-home-3d.homeManager = {pkgs, sources, ...}: let
    unwrappedApplication = pkgs.sweethome3d.application.overrideAttrs (old: {
      # Java2D OpenGL produced blank menus under Cinnamon. The bundled Java 3D
      # 1.5.2 renderer avoids the newer renderer's NVIDIA GLX context failure.
      postInstall =
        (old.postInstall or "")
        + ''
          substituteInPlace $out/bin/sweethome3d \
            --replace-fail \
              "-Dsun.java2d.opengl=true" \
              "-Dsun.java2d.opengl=false -Dcom.eteks.sweethome3d.j3d.version=1.5.2"
        '';
    });

    # Run the X11 application through xpra to avoid the severe XWayland lag
    # observed on the NVIDIA host without requiring a separate X11 desktop.
    launcher = pkgs.writeShellApplication {
      name = "sweethome3d";
      text = ''
        printf -v childCommand '%q ' \
          "${unwrappedApplication}/bin/sweethome3d" \
          "$@"
        exec ${pkgs.xpra}/bin/xpra seamless \
          --backend=x11 \
          --opengl=no \
          --input-devices=xi \
          --clipboard=no \
          --pulseaudio=no \
          --speaker=no \
          --microphone=no \
          --printing=no \
          --webcam=no \
          --mdns=no \
          --start-child="$childCommand" \
          --exit-with-children=yes \
          --attach=yes
      '';
    };

    application = pkgs.symlinkJoin {
      name = "sweethome3d-xpra";
      paths = [unwrappedApplication];
      postBuild = ''
        rm "$out/bin/sweethome3d"
        ln -s "${launcher}/bin/sweethome3d" "$out/bin/sweethome3d"
      '';
    };
  in {
    home.packages = [application];

    home.file.".eteks/sweethome3d/plugins/sh3d-mcp-plugin-${sources.sweethome3d-mcp-plugin.version}.sh3p".source = sources.sweethome3d-mcp-plugin.src;
  };
}
