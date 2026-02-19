{
  beamPackages,
  callPackages,
  engine,
  lib,
}:
let
  version = builtins.readFile ../version.txt;
in
  beamPackages.mixRelease rec {
    pname = "expert";
    inherit version;

    src = lib.fileset.toSource {
      root = ./..;
      fileset = lib.fileset.unions [
        ../apps
        ../mix_credo.exs
        ../mix_dialyzer.exs
        ../mix_includes.exs
        ../version.txt
      ];
    };

    mixNixDeps = callPackages ../apps/expert/deps.nix {
      inherit lib beamPackages;
    };

    mixReleaseName = "plain";

    env.EXPERT_ENGINE_BUILD_PATH = "${engine}";

    preConfigure = ''
      cd apps/expert
    '';

    postInstall = ''
      mv $out/bin/plain $out/bin/expert
      wrapProgram $out/bin/expert --add-flag "eval" --add-flag "System.no_halt(true); Application.ensure_all_started(:xp_expert)" --set EXPERT_ENGINE_BUILD_PATH ${engine}
    '';

    removeCookie = false;

    passthru = {
      # not used by package, but exposed for repl and direct build access
      # e.g. nix build .#expert.mixNixDeps.jason
      inherit mixNixDeps;
    };

    meta.mainProgram = "expert";
  }
