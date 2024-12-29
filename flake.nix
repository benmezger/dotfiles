{
  description = "Personal Nix configuration";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
  };


  outputs = { self, home-manager, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      evaledConfig = nixpkgs.lib.evalModules {
        modules = [ ./conf.nix ];
      };
      userConf = evaledConfig.config;
    in {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        "default" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit userConf inputs outputs; };
          modules = [ ./hosts/default ];
        };
      };

      homeConfigurations = {
        "${userConf.username}@${userConf.hostname}" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = {
            inherit userConf inputs outputs;
          };
          modules = [ ./home/default/default.nix ];
        };
      };
    };
}
