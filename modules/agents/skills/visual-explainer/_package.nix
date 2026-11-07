{
  lib,
  buildNpmPackage,
  makeWrapper,
  applyPatches,
  jq,
  chromium,
  ffmpeg,
  src,
  version,
}:
buildNpmPackage {
  pname = "visual-explainer";
  inherit version;
  # nix-update generates the lockfile from this prepared source too.
  src = applyPatches {
    name = "visual-explainer-source-${version}";
    inherit src;
    postPatch = ''
      ${jq}/bin/jq '.dependencies["playwright-core"] = .devDependencies["playwright-core"] | del(.devDependencies) | .overrides["image-size"] = "^2.0.4"' package.json > package.json.tmp
      mv package.json.tmp package.json
      echo legacy-peer-deps=true > .npmrc
    '';
  };

  npmDepsHash = "sha256-ZdyYXhE3ZwsffcjovE2G3p5va6YmCPakIm/1TmAvpag=";
  npmFlags = ["--legacy-peer-deps"];
  dontNpmBuild = true;
  nativeBuildInputs = [makeWrapper jq];

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    for file in kit/look.mjs video/render.mjs; do
      substituteInPlace "plugins/visual-explainer/$file" \
        --replace-fail 'chromium.launch()' 'chromium.launch({ executablePath: "${chromium}/bin/chromium" })'
    done
  '';

  postInstall = ''
    # Keep dependencies inside the skill when agent-skills copies its directory.
    mv "$out/lib/node_modules/visual-explainer/node_modules" "$out/lib/node_modules/visual-explainer/plugins/visual-explainer/"
    for executable in "$out"/bin/*; do
      wrapProgram "$executable" --prefix PATH : ${lib.makeBinPath [ffmpeg chromium]}
    done
  '';
}
