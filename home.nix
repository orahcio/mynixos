{ pkgs, stable, ... }:

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
  
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      complete -F _command doas
    '';
  };

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

  programs.firefox = {
    enable = true;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # Montar Googledrive com ocamfuse depois de se conectar a internet
  # Lembrar que só faz sentido depois de configurar o google-drive-ocamfuse
  systemd.user.services.orahcioDrive = {
    # assim que tiver online o serviço excecuta
    Unit = {
      After = [ "network.target" ];
      Description = "Montar meu drive pessoal assim que logar na rede";
    };
    Service = {
      Type = "forking";
      User = "orahcio";
      ExecStart = ''${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse /home/orahcio/GoogleDrive'';
      ExecStop = ''fusermount -u /home/orahcio/GoogleDrive'';
      Restart = "always";
    };
    # só inicia o serviço depois que fazer o login
    Install.WantedBy = [ "default.target" ];
  };

  home.packages = with stable; [
    (texlive.combine { inherit (texlive)
      scheme-small
      standalone
      pgf
      xcolor
      circuitikz
      preview
      varwidth
      scontents
      ucs
      units
      physics
      unicode-math
      lualatex-math
      siunitx
      mathpazo
      l3kernel
      gensymb
      cancel
      comment
      tcolorbox # usada no pandoc pra converter .ipynb
      environ # pandoc idem
      pdfcolmk # pandoc
      titling # pandoc
      rsfs # pandoc24.05
      adjustbox # pandoc
      collectbox # pandoc
      abntex2
      mparhack
      nomencl # usado no article do abntex2
      wrapfig
      sidecap
      subfigure
      enumitem
      lastpage
      lipsum
      biblatex
      biblatex-abnt
      pgfplots
      xpatch
      biber;
    })
    typst
    typst-live
    lyx
    tor-browser-bundle-bin
    google-chrome
    pkgs.microsoft-edge
    xournalpp
    inkscape
    gimp
    krita
    gImageReader
    kitty
    zoom-us
    jabref
    poppler_utils
    manim
    labplot
    google-drive-ocamlfuse
    lynx
    ncgopher
    pkgs.zapzap
    evolution
    hexchat
    minecraft # os pkgs são do repositório instável
    maelstrom
    presenterm
    tmux
    (python3.withPackages(ps: with ps; [
      setuptools
      cython
      pyzmq
      ipykernel
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
    ]))
    (rWrapper.override{ packages = with rPackages; [
      ggplot2
      IRkernel
      languageserver
    ]; })
  ];

}

