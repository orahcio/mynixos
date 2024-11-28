{ pkgs, inputs, ... }:
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
  home.username = "meuguix";
  home.homeDirectory = "/home/meuguix";
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
	];

  # Since we do not install home-manager, you need to let home-manager
  # manage your shell, otherwise it will not be able to add its hooks
  # to your profile.
  programs.home-manager.enable = true;
  
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      complete -F _command doas
    '';
  };
  
  programs.qutebrowser = {
		enable = true;
		settings = {
			qt.force_platform = "wayland";
		};
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

  # home.packages = with pkgs; [
  # ];

}
