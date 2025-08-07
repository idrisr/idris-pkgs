# idris-pkgs

A flake-native package set for Haskell, Bash, and beyond.

This flake exposes a clean overlay of personal tools — including compiled Haskell packages, Bash scripts, CLI tools, and dev utilities — structured for reuse across multiple Nix-based projects.

## 🔧 Features

- **Multi-language**: packages in Haskell, Bash, and other toolchains
- **Composable overlay**: use via `inputs.idris-pkgs.overlays.default`
- **Reusable**: consumed by system, home-manager, and project-level flakes
- **Reproducible**: fully locked, with `nix flake check` and per-system support

## 🚀 Usage

In your `flake.nix`:

```nix
{
  inputs.idris-pkgs = {
    url = "github:idrisr/idris-pkgs";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, idris-pkgs, ... }@inputs: {
    overlays.default = final: prev:
      inputs.idris-pkgs.overlays.default final prev;
  };
}
