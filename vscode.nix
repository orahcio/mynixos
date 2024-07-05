{ pkgs, ...}:
{
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    userSettings = {
      "git.confirmSync" = false;
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };
      "workbench.colorTheme" = "Gruvbox Dark Soft";
      "files.autoSave" = "afterDelay";
      "editor.fontFamily" = "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
      "editor.fontLigatures" = true;
      "cSpell.language" = "en,pt,pt_BR";
    };
    extensions = with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-pt-br
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