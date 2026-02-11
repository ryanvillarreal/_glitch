{
  description = "v.01";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xj = {
      url = "github:ryanvillarreal/xj";
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
      specialArgs = { inherit inputs; };

      # Define shared modules to avoid repetition
      sharedModules = [
        home-manager.nixosModules.home-manager
        disko.nixosModules.disko
      ];
    in
    {
      # Physical machine configurations
      nixosConfigurations.thonk = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit specialArgs;
        modules = [ ./hosts/thonk/default.nix ] ++ sharedModules;
      };

      nixosConfigurations.mini = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        inherit specialArgs;
        modules = [ ./hosts/mini/default.nix ] ++ sharedModules;
      };

      # VM configurations with blank disk formatting
      nixosConfigurations.mini-vm-x86 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit specialArgs;
        modules = [ ./hosts/mini/vm.nix ] ++ sharedModules;
      };

      nixosConfigurations.mini-vm-arm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        inherit specialArgs;
        modules = [ ./hosts/mini/vm.nix ] ++ sharedModules;
      };
    };
}
