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
  home.stateVersion = "24.05";
  
  # Para permitir pacotes unfree pra serem instalados
  nixpkgs.config.allowUnfree = true;

  # Since we do not install home-manager, you need to let home-manager
  # manage your shell, otherwise it will not be able to add its hooks
  # to your profile.
  programs.home-manager.enable = true;
  
  # Hyprland
  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
    
    # Configurações
    settings = {
      "$terminal" = "kitty";
      "$filemanager" = "dolphin";
      "$menu" = "wofi --show drun";

      exec-once = [
        "$terminal"
        "waybar"
      ];

      input = {
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };
      gestures = {
        workspace_swipe = true;
      };

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, $menu"
      ];
    };
  };
  
  # Direnv (ref. SergeK https://discourse.nixos.org/t/reproducible-direnv-setup-on-nixos/20006/2)
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      complete -F _command doas
    '';
  };
  
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
    icons = true;
  };

  programs.bat.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fastfetch
    '';
    functions = {
      llama_run = {
        body = ''
        set -l __args $argv
        ollama run codestral $__args'';
      };
    };
  };
  
  imports = [
    ./starship.nix
    ./neovim.nix
    ./vscode.nix
  ];
  
  # programs.neovim.enable = true;
  
  programs.git = {
    enable = true;
    userName = "orahcio";
    userEmail = "orahcio@gmail.com";
  };
  
  programs.firefox.enable = true;

  programs.qutebrowser = {
    enable = true;
    # package = stable.qutebrowser;
    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?t=h_&q={}&ia=web";
      nixpkgs = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      nw = "https://nixos.wiki/index.php?search={}&go=Go";
      mynix = "https://mynixos.com/search?q={}";
      pip = "https://pypi.org/search/?q={}";
      yt = "https://www.youtube.com/results?search_query={}";
      gg = "https://www.google.com/search?q={}";
      ft = "https://12ft.io/{}";
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  
  home.packages = with pkgs; [
    xournalpp
    kile
    # inkscape
    # gimp
    jabref
    poppler_utils
    pdfarranger
    libreoffice-qt
    hunspell
    hunspellDicts.pt_BR
    hunspellDicts.en_US
    hexchat
    maelstrom
    twtxt
    sqlitebrowser
    tor-browser
    steam-run
    # Coisas de email e redes sociais
    thunderbird
    # O neomutt precis de python para rodar o script de OAuth
    neomutt
    w3m # Para ler email html
    python311
    # Coisas para o Hyprland
    kitty
    wofi
    waybar
    # Coisas para o kate
    texlab
    python311Packages.python-lsp-server
    nil
  ];

}
