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
  
  imports = [
    ./starship.nix
    ./vscode.nix
    ./neovim.nix
  ];
  
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
      if test $TERM = 'xterm-kitty'
	fastfetch --logo ~/Imagens/nix-snowflake-colours.png --logo-type kitty-direct --logo-width 50 --logo-height 25
      else
	fastfetch
      end
    '';
    loginShellInit = ''
      espanso start --unmanaged
    '';
    functions = {
      llama_run = {
        body = ''
        set -l __args $argv
        ollama run llama3.1 $__args'';
      };
    };
  };
  
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
			nd = "https://discourse.nixos.org/search?q={}";
      mynix = "https://mynixos.com/search?q={}";
      pip = "https://pypi.org/search/?q={}";
      yt = "https://www.youtube.com/results?search_query={}";
      gg = "https://www.google.com/search?q={}";
			wf = "https://www.wolframalpha.com/input?i={}";
			ft = "https://12ft.io/{}";
    };
    keyBindings = {
      normal = {
        ",m" = "spawn umpv {url}";
				",M" = "hint links spawn umpv {hint-url}";
				",p" = "spawn --userscript qute-pass";
      };
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  home.packages = with pkgs; [
		# Coisas de Office
    xournalpp
    kile
    zathura
    mupdf
    # inkscape
    # gimp
    jabref
    # poppler_utils
    # pdfarranger
    libreoffice-qt
    hunspell
    hunspellDicts.pt_BR
    hunspellDicts.en_US

    # E-mail, bate-papos e miscelânea
    thunderbird
    hexchat
    element-desktop
    twtxt
    tor-browser
    steam-run
    pass-wayland
    espanso-wayland
    rclone
    maelstrom
    zoom-us
    # sqlitebrowser
    # O neomutt precis de python para rodar o script de OAuth
    # neomutt
    # w3m # Para ler email html
    # python311

    # Coisas para desenvolvimento no kate
    texlab
    python311Packages.python-lsp-server
    nil

    # Mais coisas de desenvolvimento
    conda
  ];

}
