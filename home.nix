{ pkgs, lib, config, inputs, ... }:
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
	# home.sessionPath = [
	# 	"$HOME/.guix-profile/bin"
	# ];

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
  home.stateVersion = "24.11";
  
  # Para permitir pacotes unfree pra serem instalados
  nixpkgs.config.allowUnfree = true;

	# Overlays no home-manager
	nixpkgs.overlays = [
		( final: _prev: {
			unstable = import inputs.nixpkgs-unstable {
				system = final.system;
				config.allowUnfree = true;
				};
			}
		)		
		( final: prev: {
				vimPlugins = prev.vimPlugins // {
					own-tree-sitter-context = prev.vimUtils.buildVimPlugin {
						name = "tree-siter-context";
						src = inputs.plugin-tree-sitter-context;
					};
				};
		})
	];

  # Since we do not install home-manager, you need to let home-manager
  # manage your shell, otherwise it will not be able to add its hooks
  # to your profile.
  programs.home-manager.enable = true;
  
	# Temas
	qt.enable = true;
	gtk.enable = true;

	qt.platformTheme.name = "gtk";

	# Tema GTK
	gtk.theme.package = pkgs.gruvbox-gtk-theme;
	gtk.theme.name = "Gruvbox-Light";

	# Ícones
	gtk.iconTheme.package = pkgs.gruvbox-plus-icons;
	gtk.iconTheme.name = "Gruvbox-Plus-Dark";

	# Cursor
	gtk.cursorTheme.package = pkgs.posy-cursors; 
	gtk.cursorTheme.name = "Posy_Cursor_Black"; 
	gtk.cursorTheme.size = 64; 

	home.pointerCursor = {
		gtk.enable = true;
		x11.enable = true;
		package = pkgs.posy-cursors; 
		name = "Posy_Cursor_Black";
		size = 64;
	};

	# Configurações para o sway
	# home.file.".config/sway/config".source = ./sway/config;
	# Waybar
	# home.file.".config/waybar/config.jsonc".source = ./sway/waybar/config.jsonc;
	# home.file.".config/waybar/style.css".source = ./sway/waybar/style.css;
	# home.file.".config/waybar/power_menu.xml.css".source = ./sway/waybar/power_menu.xml;

  imports = [
    ./starship.nix
    # ./vscode.nix
    ./neovim.nix
		./sway.nix
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
    icons = "auto";
  };

  programs.bat.enable = true;

  programs.fish = {
    enable = true;
		plugins = [
			{
    		name = "foreign-env";
    		src = pkgs.fetchFromGitHub {
      	owner = "oh-my-fish";
      	repo = "plugin-foreign-env";
      	rev = "7f0cf099ae1e1e4ab38f46350ed6757d54471de7";
      	sha256 = "4+k5rSoxkTtYFh/lEjhRkVYa2S4KEzJ/IJbyJl+rJjQ=";
    };
  }
		];
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
			
			# Guix variables, ref.: https://gist.github.com/Pinjontall94/4dfbf1e1b1a8327f10b010ee06f413d1

			set -gx GUIX_PROFILE ~/.config/guix/current
			# fish_add_path "$GUIX_PROFILE/bin"
			fenv source $GUIX_PROFILE/etc/profile
			set -gax XDG_DATA_DIRS "$GUIX_PROFILE/share"
			set -gx GUILE_LOAD_COMPILED_PATH "$GUIX_PROFILE/lib/guile/3.0/site-ccache $GUIX_PROFILE/share/guile/site/3.0"
			set -gx GUILE_LOAD_PATH "$GUIX_PROFILE/share/guile/site/3.0"
			set -gx GUIX_LOCPATH "$HOME/.guix-profile/lib/locale"
    '';
    functions = {
      funfetch = {
        body = ''
					if test $TERM = 'xterm-kitty'
						fastfetch --logo ~/Imagens/nix-snowflake-colours.png --logo-type kitty-direct --logo-width 50 --logo-height 25
      		else
						fastfetch
					end
				# set -l __args $argv
				# ollama run llama3.1 $__args'';
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
		settings = {
			qt.force_platform = "wayland";
		};
    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?t=h_&q={}&ia=web";
      nixpkgs = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      nw = "https://nixos.wiki/index.php?search={}&go=Go";
			nwo = "https://wiki.nixos.org/w/index.php?search={}";
  		nd = "https://discourse.nixos.org/search?q={}";
      mynix = "https://mynixos.com/search?q={}";
      pip = "https://pypi.org/search/?q={}";
      yt = "https://www.youtube.com/results?search_query={}";
      gg = "https://www.google.com/search?q={}";
  		wf = "https://www.wolframalpha.com/input?i={}";
  		ft = "https://12ft.io/{}";
			gx = "https://packages.guix.gnu.org/search/?query={}";
    };
    keyBindings = {
      normal = {
        ",m" = "spawn umpv {url}";
  		",M" = "hint links spawn umpv {hint-url}";
  		",p" = "spawn --userscript qute-pass";
      };
    };
  };

	# programs.emacs = {
	# 	enable = true;
	# 	extraPackages = epkgs: [ epkgs.auctex ];
	# };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  home.packages = (with pkgs; [
		# Coisas de Office
    jabref
    xournalpp
    zathura
		# mupdf
    # poppler_utils
    pdfarranger
    # libreoffice-qt
    # hunspell
    # hunspellDicts.pt_BR
    # hunspellDicts.en_US
		# texworks
		emacs

    # E-mail, bate-papos e miscelânea
    thunderbird
    element-desktop
    twtxt
    tor-browser
    steam-run
    pass-wayland
    rclone

		# IRC
		quassel

		# Podcasts
		gpodder

		# Sway
		mako # Notificação
		wpaperd # Papel de parede em slides
		pcmanfm # Gerenciador de arquivos
		lxmenu-data # Complemento para o ocmanfm
		shared-mime-info # Complemento para o pcmanfm
		kitty # Terminal
		pw-volume
		pavucontrol
		networkmanagerapplet # Gerenciar redes na barra
		mpv
		grim # Screenshot da tela
		slurp # Screenshot de uma região da tela
		swappy # Editar screenshot
		wl-clipboard
		xdg-desktop-portal-wlr
		swayimg # Visualizar imagens
		yambar

		# Um wm para wayland
		# (dwl.overrideAttrs { src = /home/orahcio/mynixos/dwl; })
		# foot
		# wmenu

    # sqlitebrowser
    # O neomutt precis de python para rodar o script de OAuth
    # neomutt
    # w3m # Para ler email html
    # python311

    # Coisas para desenvolvimento no kate
    # texlab
    # python311Packages.python-lsp-server
    # nil
  ]) ++ (with pkgs.kdePackages; [
			ark
			filelight
		]);

}
