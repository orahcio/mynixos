{
  description = "Configuração do NixOS de Orahcio";

  inputs = {
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-2.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
		plugin-tree-sitter-context.url = "github:pmazaitis/tree-sitter-context";
		plugin-tree-sitter-context.flake = false;
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, lix-module, home-manager, ... }:
		let
			system = "x86_64-linux";
			pkgs = import nixpkgs {
				inherit system;
				config.allowUnfree = true;
			};
			# stable = import nix-stable {
			# 	inherit system;
			#      config.allowUnfree = true;
			#  	};
    in
			{
				nixosConfigurations = {
					goldenfeynman = nixpkgs.lib.nixosSystem {
						system = "x86_64-linux";
						specialArgs = { inherit inputs; };
						modules = [
							lix-module.nixosModules.default
							./configuration.nix
							# (import ./overlays)
							# home-manager.nixosModules.home-manager
							# {
							# 	home-manager.useGlobalPkgs = false;
							# 	home-manager.useUserPackages = true;
							# 	home-manager.extraSpecialArgs = { inherit inputs; };
							# 	home-manager.users.orahcio = import ./home.nix;
							# 	home-manager.backupFileExtension = "old_backup"; # Adicionado para sobrepor as configurações diretas na minha home, fazendo um backup das mesmas
							# 	# home-manager.users.ilana = import ./home_ilana.nix;
							#
							# 	# Optionally, use home-manager.extraSpecialArgs to pass
							# 	# arguments to home.nix
							# }
						];
					};
				};

				homeConfigurations = {
					"orahcio" = home-manager.lib.homeManagerConfiguration {
						pkgs = import nixpkgs { system = "x86_64-linux"; };
						modules = [ ./home.nix ]; # Defined later
						extraSpecialArgs = { inherit inputs; };
          };
        };
  		};
}
