{
  description = "v.01";

  inputs = {
    # Core NixOS packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # User environment management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disk partitioning as code
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Tool to generate various formats (like ISOs)
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      disko,
      nixos-generators,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
    in
    {
      # Usage: nixos-rebuild build-vm --flake .#thonk
      nixosConfigurations.thonk = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ./hosts/thonk/default.nix
          home-manager.nixosModules.home-manager
          disko.nixosModules.disko
        ];
      };
    };
}
