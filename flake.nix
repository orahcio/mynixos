{
  description = "Configuração do NixOS de Orahcio";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";
    home-manager.url = "https://flakehub.com/f/nix-community/home-manager/0.1.2984.tar.gz";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
  let
  	system = "x86_64-linux";
	pkgs = import nixpkgs {
		inherit system;
		config.allowUnfree = true;
	};
	# unstable = import nixpkgs-unstable {
	# 	inherit system;
	# 	config.allowUnfree = true;
	# };
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
            # home-manager.extraSpecialArgs = { inherit unstable; };
            home-manager.users.orahcio = import ./home.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
