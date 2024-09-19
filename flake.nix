{
  description = "Configuração do NixOS de Orahcio";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nix-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    old-libgit2.url = "github:NixOS/nixpkgs/a6c20a73872c4af66ec5489b7241030a155b24c3";
  };

  outputs = inputs@{ self, nixpkgs, lix-module, home-manager, ... }:
  {
    nixosConfigurations = {
      goldenfeynman = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          lix-module.nixosModules.default
          ./configuration.nix
          # (import ./overlays)
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # home-manager.extraSpecialArgs = { inherit stable; };
            home-manager.users.orahcio = import ./home.nix;
            home-manager.backupFileExtension = "old_backup"; # Adicionado para sobrepor as configurações diretas na minha home, fazendo um backup das mesmas
            # home-manager.users.ilana = import ./home_ilana.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };
    };
  };
}
