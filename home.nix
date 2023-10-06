{ pkgs, ... }:

{

  # The home-manager manual is at:
  #
  #   https://rycee.gitlab.io/home-manager/release-notes.html
  #
  # Configuration options are documented at:
  #
  #   https://rycee.gitlab.io/home-manager/options.html

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  #
  # You need to change these to match your username and home directory
  # path:
  home.username = "orahcio";
  home.homeDirectory = "/home/orahcio";

  # If you use non-standard XDG locations, set these options to the
  # appropriate paths:
  #
  # xdg.cacheHome
  # xdg.configHome
  # xdg.dataHome

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Since we do not install home-manager, you need to let home-manager
  # manage your shell, otherwise it will not be able to add its hooks
  # to your profile.
  programs.home-manager.enable = true;
  
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  
  programs.bash.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "kitty"; 
      startup = [
        # Launch Firefox on start
        {command = "firefox";}
      ];
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    # extensions = with pkgs.vscode-extensions; [
    #   dracula-theme.theme-dracula
    #   vscodevim.vim
    #   yzhang.markdown-all-in-one
    #   ms-python.python
    #   ms-toolsai.jupyter
    #   ms-ceintl.vscode-language-pack-pt-br
    #   github.vscode-pull-request-github
    #   arrterian.nix-env-selector
    #   bungcip.better-toml
    #   grapecity.gc-excelviewer
    # ];
  };
  
  programs.git = {
    enable = true;
    userName = "orahcio";
    userEmail = "orahcio@gmail.com";
  };
  # programs.vim = {
  #   enable = true;
  #   plugins = with pkgs.vimPlugins; [ vim-lastplace vim-nix YouCompleteMe ];
  #   settings = { ignorecase = true; };
  #   extraConfig = ''
  #     set mouse=a
  #   '';
  # };
  
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set number relativenumber
    '';
  };

  home.packages = with pkgs; [
    (texlive.combine { inherit (texlive)
      scheme-small
      standalone
      varwidth
      scontents
      ucs
      units
      unicode-math
      lualatex-math
      siunitx
      l3kernel
      gensymb
      cancel
      comment
      tcolorbox # usada no pandoc pra converter .ipynb
      environ # pandoc idem
      pdfcolmk # pandoc
      titling # pandoc
      rsfs # pandoc
      adjustbox # pandoc
      collectbox # pandoc
      abntex2
      nomencl
      wrapfig
      enumitem
      lastpage
      lipsum
      biblatex
      biblatex-abnt
      pgfplots
      xpatch
      biber;
    })
    kile
    lyx
    libsForQt5.kruler
    libsForQt5.kasts
    libsForQt5.neochat
    libsForQt5.kcalc
    libsForQt5.kontact
    libsForQt5.kmail
    libsForQt5.akonadi
    qutebrowser
    tor-browser-bundle-bin
    google-chrome
    xournalpp
    inkscape
    gimp
    krita
    gImageReader
    kitty
    zoom-us
    poppler_utils
    (python3.withPackages(ps: with ps; [
      setuptools
      cython
      pyzmq
      jupyter
      notebook
      numpy
      matplotlib
      scipy
      ffmpeg-python
      sympy
      ipympl
      pandoc
      nbconvert
      pandas
      openpyxl
      astropy
    ]))
    (rWrapper.override{ packages = with rPackages; [
      ggplot2
      IRkernel
      languageserver
    ]; })
  ];

}

