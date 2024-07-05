{ pkgs, ...}:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-toolsai.jupyter
      ms-toolsai.vscode-jupyter-slideshow
      ms-toolsai.vscode-jupyter-cell-tags
      yzhang.markdown-all-in-one
      mkhl.direnv
      asvetliakov.vscode-neovim
      streetsidesoftware.code-spell-checker
      ms-python.vscode-pylance
      ms-python.python
      ms-python.debugpy
      jnoortheen.nix-ide
      mkhl.direnv
      jdinhlife.gruvbox
    ]  ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "code-spell-checker-portuguese-brazilian";
        publisher = "streetsidesoftware";
        version = "2.2.1";
        # sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
      };
    ];
  };
}