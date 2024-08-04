{
  description = "Configuração do NixOS de Orahcio";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0-rc1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, nix-stable, lix-module, home-manager, ... }:
  let
  	system = "x86_64-linux";
	pkgs = import nixpkgs {
		inherit system;
		config.allowUnfree = true;
	};
  stable = import nix-stable {
    inherit system;
    config.allowUnfree = true;
  };
  in
  {
    nixosConfigurations = {
      goldenfeynman = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          {
            _module.args = { inherit stable; };
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit stable; };
            home-manager.users.orahcio = import ./home.nix;
            home-manager.backupFileExtension = "backup-"; # Adicionado para sobrepor as configurações diretas na minha home, fazendo um backup das mesmas
            # home-manager.users.ilana = import ./home_ilana.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
          lix-module.nixosModules.default
        ];
      };
    };
  };
}
