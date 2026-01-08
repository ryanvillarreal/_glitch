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

      # Define shared modules to avoid repetition
      sharedModules = [
        home-manager.nixosModules.home-manager
        disko.nixosModules.disko
      ];
    in
    {
      nixosConfigurations.thonk = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [ ./hosts/thonk/default.nix ] ++ sharedModules;
      };

      nixosConfigurations.mini = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [ ./hosts/mini/default.nix ] ++ sharedModules;
      };

      packages.${system} = {
        thonk = self.nixosConfigurations.thonk.config.system.build.toplevel;
        mini = self.nixosConfigurations.mini.config.system.build.toplevel;
      };
    };
}
