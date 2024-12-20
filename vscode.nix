{ pkgs, ...}:
{
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    userSettings = {
      "git.confirmSync" = false;
      "extensions.autoUpdate" = false;
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };
      "workbench.colorTheme" = "Gruvbox Dark Soft";
      "files.autoSave" = "afterDelay";
      "editor.fontFamily" = "'FiraCode Nerd Font', 'Droid Sans Mono', 'monospace', monospace";
      "editor.fontLigatures" = true;
      "cSpell.language" = "en,pt,pt_BR";
      # Widgets no jupyter
      "jupyter.widgetScriptSources" = ["jsdelivr.com" "unpkg.com"];
			"jupyter.askForKernelRestart" = false;
			"git.autofetch" = true;
			"terminal.integrated.inheritEnv" = false;
    };
    extensions = with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-pt-br
      ms-toolsai.jupyter
      ms-toolsai.vscode-jupyter-slideshow
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.datawrangler
      yzhang.markdown-all-in-one
      mkhl.direnv
      # asvetliakov.vscode-neovim
			vscodevim.vim
      streetsidesoftware.code-spell-checker
      ms-python.vscode-pylance
      ms-python.python
      ms-python.debugpy
      ms-vscode.cpptools-extension-pack
      ms-vscode.cpptools
      ms-vscode.cmake-tools
      jnoortheen.nix-ide
      mkhl.direnv
      jdinhlife.gruvbox
			# continue.continue
    ]  ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "code-spell-checker-portuguese-brazilian";
        publisher = "streetsidesoftware";
        version = "2.2.1";
        sha256 = "wwtlNl1WWeroL8tQotuk56SP8dxc6n5O/gQRuuEC3Bc=";
      }
			# {
			# 	name = "vscode-cython";
			# 	publisher = "ktnrg45";
			# 	version = "1.0.3";
			# 	sha256 = "sha256-aK1OFwRc5skLokuEFiZkGVgqaI22PTXGF1E16cx0EDQ=";
			# }
			{
				name = "language-cython";
				publisher = "guyskk";
				version = "0.0.8";
				sha256 = "w/gT/oWNLdMlOmpN+efBPg6SdhXHuC8lakUFu/GgJyc=";
			}
    ];
  };
}
