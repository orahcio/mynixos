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
        sha256 = "wwtlNl1WWeroL8tQotuk56SP8dxc6n5O/gQRuuEC3Bc=";
      }
    ];
  };
}