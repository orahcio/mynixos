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

	# Sway no wayland
	wayland.windowManager.sway = {
    enable = true;
		wrapperFeatures.gtk = true;
		config = rec {
      modifier = "Mod4";
      terminal = "kitty"; 
			menu = "${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu -b | ${pkgs.findutils}/bin/xargs swaymsg exec --";
			defaultWorkspace = "workspace number 1:  ";
			input = {
				"*".xkb_layout = "br";
				"1739:32382:DELL0828:00_06CB:7E7E_Touchpad" = { #"2:7:SynPS/2_Synaptics_TouchPad" = {
					dwt = "enabled";
       		tap = "enabled";
       		natural_scroll = "enabled";
       		middle_emulation = "enabled";
				};
			};
			output = {
				eDP-1.resolution = "1920x1080@60.049Hz";
				HDMI-A-1 = {
					resolution = "1920x1080";
					position = "1920,0";
				};
			};
			seat."*" = { xcursor_theme = "Posy_Cursor_Black 64"; };
			gaps = {
				top = 5;
			};
			floating.criteria = [
				{ app_id = "pavucontrol"; }
				{ app_id = "mpv"; }
			];
			window.commands = [
				{ command = "border none"; criteria.app_id = "mpv"; }
				{ command = "resize set width 350";	criteria.app_id = "mpv"; }
				{ command = "sticky enable";	criteria.app_id = "mpv"; }
				{ command = "move absolute position 1400 750";	criteria.app_id = "mpv"; }
			];
			keybindings =
				let
					mod4 = config.wayland.windowManager.sway.config.modifier;
					wp1 = "number 1:  ";
					wp2 = "number 2:  ";
					wp3 = "number 3:  ";
					wp4 = "number 4:  ";
					wp5 = "number 5:  ";
				in lib.mkOptionDefault {
						"${mod4}+Shift+Return" = "exec qutebrowser";
						"${mod4}+1" = "workspace ${wp1}";
						"${mod4}+2" = "workspace ${wp2}";
						"${mod4}+3" = "workspace ${wp3}";
						"${mod4}+4" = "workspace ${wp4}";
						"${mod4}+5" = "workspace ${wp5}";
						"${mod4}+Shift+1" = "move container to workspace ${wp1}";
						"${mod4}+Shift+2" = "move container to workspace ${wp2}";
						"${mod4}+Shift+3" = "move container to workspace ${wp3}";
						"${mod4}+Shift+4" = "move container to workspace ${wp4}";
						"${mod4}+Shift+5" = "move container to workspace ${wp5}";
						"Print" = "exec grim -o eDP-1";
						"${mod4}+Print" = "exec grim -g \"$(slurp)\" - | swappy -f - | wl-copy";
				};
			startup = [
				{ command = "nm-applet"; }
				{ command = "wpaperd -d"; always = true; }
				{ command = "mako"; always = true; }
				{ command = "kdeconnect-indicator"; }
				# Para compartilhar a tela numa chamada
				{ command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway"; }
				# { command = "swayidle -w timeout 600 \'swaymsg \"output * power off\"\' resume \'swaymsg \"output * power on\"\'"; }
			];
			bars = [
				{
					command = "${pkgs.waybar}/bin/waybar";
					# mode = "dock";
					# statusCommand = "${pkgs.i3status}/bin/i3status";
					# trayOutput = "*";
					# fonts = {
					# 	names = [ "FontAwesome" "FiraCode Nerd Font Mono Ret" ];
					# 	size = 9.0;
					# };
				}
			];
		};
	};

	services.swayidle = {
		enable = true;
		timeouts = [
			{ timeout = 600; command = "swaymsg \"output * power off\""; resumeCommand = "swaymsg \"output * power on\""; }
		];
	};

	# Temperatura da cor
	services.gammastep = {
    enable = true;
    # provider = "geoclue2";
		# Coordenadas para Amargosa
		latitude = -13.03;
		longitude = -39.59;
		tray = true;
	};

	# Configurações para o sway
	# home.file.".config/sway/config".source = ./sway/config;
	# Waybar
	# home.file.".config/waybar/config.jsonc".source = ./sway/waybar/config.jsonc;
	# home.file.".config/waybar/style.css".source = ./sway/waybar/style.css;
	# home.file.".config/waybar/power_menu.xml.css".source = ./sway/waybar/power_menu.xml;

  imports = [
    ./starship.nix
    ./vscode.nix
    ./neovim.nix
  ];
  
  # Direnv (ref. SergeK https://discourse.nixos.org/t/reproducible-direnv-setup-on-nixos/20006/2)
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  
	programs.waybar = {
		enable = true;
		settings = [
			{
				"height" = 31;
				"spacing" = 5;
				"margin-top" = 27;
				"margin-left" = 15;
				"margin-right" = 15;
				"modules-left" = [
        	"sway/workspaces"
        	"sway/mode"
        	"sway/scratchpad"
    		];
				"modules-center" = [
	        "sway/window"
    		];
				"modules-right" = [
        	"pulseaudio"
					"memory"
					"disk"
					"backlight"
					"battery"
					"clock"
        	"tray"
					"custom/power"
    		];
				"sway/mode" = {
					"format" = "<span style=\"italic\">{}</span>";
				};
				"sway/scratchpad" = {
					"format" = "{icon} {count}";
					"show-empty" = false;
					"format-icons" = ["" ""];
					"tooltip" = true;
					"tooltip-format" = "{app}: {title}";
				};
				"pulseaudio" = {
					"format" = "{volume}% {icon} {format_source}";
        	"format-bluetooth" = "{volume}% {icon} {format_source}";
        	"format-bluetooth-muted" = " {icon} {format_source}";
        	"format-muted" = " {format_source}";
        	"format-source" = "{volume}% ";
        	"format-source-muted" = "";
        	"format-icons" = {
						"headphone" = "";
            "hands-free" = " ";
            "headset" = " ";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" =["" "" ""];
        	};
        	"on-click" = "pavucontrol";
				};
				"memory" = {
					"format" = "{avail:.1f}G ";
					"unit" = "GB";
				};
				"disk" = {
					"format" = "{free} ";
					"unit" = "GB";
				};
				"backlight" = {
					# "device": "acpi_video1",
					"format" = "{percent}% {icon}";
					"format-icons" = ["" "" "" "" "" "" "" "" ""];
				};
				"battery" = {
					"states" = {
						"goog" = 95;
						"warning" = 30;
						"critical" = 15;
					};
					"format" = "{capacity}% {icon}";
					"format-full" = "{capacity}% {icon}";
					"format-charging" = "{capacity}%  ";
					"format-plugged" = "{capacity}%  ";
					"format-alt" = "{time} {icon}";
					"format-icons" = ["" "" "" "" ""];
				};
				"clock" = {
					"timezone" = "America/Bahia";
					"format" = "{:L%a. %d %b. %Y %H:%M}";
					"tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
					"on-click" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
					"format-alt" = "{%d-%m-%Y}";
				};
				"custom/power" = {
        	"format" = "⏻ ";
					"tooltip" = false;
					"menu" = "on-click";
					"menu-file" = "$HOME/.config/waybar/power_menu.xml"; # Menu file in resources folder
					"menu-actions" = {
						"shutdown" = "shutdown";
						"reboot" = "reboot";
						"suspend" = "systemctl suspend";
						"hibernate" = "systemctl hibernate";
					};
				};
			}
		];
	};

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
    libreoffice-qt
    hunspell
    hunspellDicts.pt_BR
    hunspellDicts.en_US
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
		(dwl.overrideAttrs { src = /home/orahcio/mynixos/dwl; })
		foot
		wmenu

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
