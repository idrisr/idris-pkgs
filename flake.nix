{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.mksession = {
    url = "github:idrisr/mksession";
  };
  inputs.pdftc = {
    url = "github:idrisr/pdftc";
  };

  outputs = inputs@{ nixpkgs, flake-utils, ... }:
    let
      system = flake-utils.lib.system.x86_64-linux;
      pkgs = nixpkgs.legacyPackages.${system};
      doc = pkgs.callPackage ./doc { };
    in
    {
      overlays = {
        mksession = inputs.mksession.overlays.default;
        pdftc = inputs.pdftc.overlays.default;

        default = final: prev:
          builtins.foldl'
            (acc: overlay: acc // overlay final prev)
            { }
            [
              inputs.mksession.overlays.default
              inputs.pdftc.overlays.default
            ];
      };

      packages.${system} = {
        default = doc;
        inherit doc;
      };
    };
}
