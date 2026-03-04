{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/25.11";
    flake-utils.url = "github:numtide/flake-utils";

    mksession = {
      url = "github:idrisr/mksession";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sorta = {
      url = "github:idrisr/sorta";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pdftc = {
      url = "github:idrisr/pdftc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    videoChapter = {
      url = "github:idrisr/videoChapter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    presentationVideoManager = {
      url = "github:idrisr/presentation-video-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    newcover = {
      url = "github:idrisr/newcover";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , flake-utils
    , ...
    }:
    let
      overlay =
        final: prev:
        let
          merged = builtins.foldl' (acc: overlayFn: acc // overlayFn final prev) { } [
            inputs.mksession.overlays.default
            inputs.pdftc.overlays.default
            inputs.sorta.overlays.default
            inputs.videoChapter.overlays.default
            inputs.newcover.overlays.default
            inputs.presentationVideoManager.overlays.default
          ];
        in
        merged;
    in
    {
      overlays.default = overlay;
    }
    // flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-linux" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        };
        packageNames = [
          "mksession"
          "pdftc"
          "sorta"
          "videoChapter"
          "newcover"
          "presentationVideoManager"
        ];
        packages = pkgs.lib.attrsets.filterAttrs (name: _: builtins.elem name packageNames) pkgs;
        defaultPackage = pkgs.symlinkJoin {
          name = "idris-pkgs";
          paths = builtins.attrValues packages;
        };
      in
      {
        packages = packages // {
          default = defaultPackage;
        };
        checks = pkgs.lib.mapAttrs (_: pkg: pkg) packages;
        formatter = pkgs.writeShellApplication {
          name = "fmt";
          runtimeInputs = [
            pkgs.findutils
            pkgs.nixfmt-rfc-style
          ];
          text = ''
            mapfile -t files < <(find . -type f -name "*.nix")
            if [ "''${#files[@]}" -gt 0 ]; then
              nixfmt -- "''${files[@]}"
            fi
          '';
        };
      }
    );
}
