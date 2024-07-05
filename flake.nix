{
  description = "Configuração do NixOS de Orahcio";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # grub2-themes.url = "github:vinceliuice/grub2-themes";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0-rc1.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, lix-module, home-manager, ... }:
  let
  	system = "x86_64-linux";
	pkgs = import nixpkgs {
		inherit system;
		config.allowUnfree = true;
	};
	# stable = import nixpkgs-stable {
		# inherit system;
		# config.allowUnfree = true;
	# };
  in	
  {
    nixosConfigurations = {
      goldenfeynman = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          # grub2-themes.nixosModules.default
          home-manager.nixosModules.home-manager
          lix-module.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # home-manager.extraSpecialArgs = { inherit nixvim; };
            home-manager.users.orahcio = import ./home.nix;
            home-manager.backupFileExtension = "backup-"; # Adicionado para sobrepor as configurações diretas na minha home, fazendo um backup das mesmas
            # home-manager.users.ilana = import ./home_ilana.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
