{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.mksession = {
    # url = "github:idrisr/mksession";
    url = "/home/hippoid/fun/mksession";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.pdftc = {
    # url = "github:idrisr/pdftc";
    url = "/home/hippoid//fun/pdftc";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, flake-utils, ... }:
    {

      overlays.default = final: prev:
        let
          merged = builtins.foldl'
            (acc: overlay: acc // overlay final prev)
            { }
            [
              inputs.mksession.overlays.default
              inputs.pdftc.overlays.default
            ];
        in
        merged;
    };
}
