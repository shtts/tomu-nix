{
  description = "Nix packaging for Tomu - A simple music player";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor = system: nixpkgs.legacyPackages.${system};

      packages = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.callPackage ./default.nix { };
        }
      );

    in
    {
      homeModules.default = ./modules/home/tomu.nix;
      nixosModules.default = ./modules/nixos/tomu.nix;

      inherit packages;
    };
}
