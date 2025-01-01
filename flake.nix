{
  description = "Personal Nix configuration";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };


  outputs = { self, nix-darwin, home-manager, nixpkgs, ... }@inputs:
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
      overlays = import ./overlays { inherit inputs; };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit userConf inputs outputs; };
          modules = [
            ./modules
            ./modules/linux
            ./hosts/default
            home-manager.nixosModules.home-manager {
              home-manager = {
                extraSpecialArgs = {inherit inputs outputs;};
                users."${userConf.username}" = import ./home/default/default.nix;
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        "${userConf.osx_hostname}" = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit userConf inputs outputs; };
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            ./modules
            ./modules/osx
            ./hosts/osx
            home-manager.darwinModules.home-manager {
              home-manager = {
                useUserPackages = true;
                extraSpecialArgs = {inherit inputs outputs;};
                users."${userConf.osx_username}" = import ./home/osx/default.nix;
              };
            }
          ];
        };
      };

      # homeConfigurations = forAllSystems (system: let
      #   pkgs = nixpkgs.legacyPackages.${system};
      # in {
      #   "${userConf.username}@${userConf.hostname}" = home-manager.lib.homeManagerConfiguration {
      #     pkgs = nixpkgs.legacyPackages."${system}";
      #     extraSpecialArgs = {
      #       inherit userConf inputs outputs;
      #     };
      #     modules = [ ./home/default/default.nix ];
      #   };
      #   "${userConf.osx_username}@${userConf.osx_hostname}" = home-manager.lib.homeManagerConfiguration {
      #     pkgs = nixpkgs.legacyPackages."${system}";
      #     extraSpecialArgs = {
      #       inherit userConf inputs outputs;
      #     };
      #     modules = [ ./home/osx/default.nix ];
      #   };
      # });
    };
}
