{ config, pkgs, lib, ... }:
{
  nixpkgs.overlays = [
    (final: prev:
      let
        pkgs = import inputs.old-libgit2 {
          system = "x86_64-linux";
        };
      in
      {
        guile-git = prev.guile-git.override { libgit2 = pkgs.libgit2; };  
      })
  ];
}