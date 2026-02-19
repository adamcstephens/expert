{
  beamPackages,
  callPackages,
  lib,
}:
let
  version = builtins.readFile ../version.txt;

in
beamPackages.mixRelease {
  pname = "expert";
  inherit version;

  src = lib.fileset.toSource {
    root = ./..;
    fileset = lib.fileset.unions [
      ../apps/engine
      ../apps/forge
      ../mix_credo.exs
      ../mix_dialyzer.exs
      ../mix_includes.exs
      ../version.txt
    ];
  };

  mixNixDeps = callPackages ../apps/engine/deps.nix {
    inherit lib beamPackages;
  };

  preConfigure = ''
    cd apps/engine
  '';

  meta.mainProgram = "expert";
}
