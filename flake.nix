{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/25.05";

  inputs.mksession = {
    url = "github:idrisr/mksession";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.sorta = {
    url = "github:idrisr/sorta";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.pdftc = {
    url = "github:idrisr/pdftc";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.videoChapter = {
    url = "github:idrisr/videoChapter";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.presentationVideoManager = {
    url = "github:idrisr/presentation-video-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };


  outputs = inputs@{ nixpkgs, ... }:
    {
      overlays.default = final: prev:
        let
          merged = builtins.foldl'
            (acc: overlay: acc // overlay final prev)
            { }
            [
              inputs.mksession.overlays.default
              inputs.pdftc.overlays.default
              inputs.sorta.overlays.default
              inputs.videoChapter.overlays.default
              inputs.presentationVideoManager.overlays.default
            ];
        in
        merged;
    };
}
