{
  description = "Configuração do NixOS de Orahcio";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs = inputs@{ nixpkgs, home-manager, nixpkgs-stable, ... }:
  let
  	system = "x86_64-linux";
	pkgs = import nixpkgs {inherit system;};
	stable = import nixpkgs-stable {inherit system;};
  in	
  {
    nixosConfigurations = {
      goldenfeynman = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit stable; };
            home-manager.users.orahcio = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
