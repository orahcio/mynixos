# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:
let
  # nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
  #   export __NV_PRIME_RENDER_OFFLOAD=1
  #   export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
  #   export __GLX_VENDOR_LIBRARY_NAME=nvidia
  #   export __VK_LAYER_NV_optimus=NVIDIA_only
  #   exec -a "$0" "$@"
  # '';

	tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "${pkgs.sway}/bin/sway"; # --unsupported-gpu";
  username = "orahcio";
in
{
  # Diretório com as configurações, para não ficar mais em /etc/nixos
  # nix.nixPath = [
  #   "nixos-config=/home/orahcio/mynixos/configuration.nix"
  #   "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
  #   "home-manager=/nix/var/nix/profiles/per-user/root/channels/home-manager"
  # ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
			# ./nvidia.nix
      # <home-manager/nixos>
    ];
  
	# Overlays
  nixpkgs.overlays = [
		( final: _prev: {
			unstable = import inputs.nixpkgs-unstable {
				system = final.system;
				config.allowUnfree = true;
				};
			}
		)
  ];

  # Filesystem
  fileSystems."/mnt/jogosemais" = {
    device = "/dev/disk/by-uuid/dd0f594d-df87-4485-8654-69af92e27aea";
    fsType = "ext4";
    options = [ # If you don't have this options attribute, it'll default to "defaults" 
      # boot options for fstab. Search up fstab mount options you can use
      "users" # Allows any user to mount and unmount
      "exec" # Para permitir execução
      "nofail" # Prevent system from failing if this drive doesn't mount
    ];
  };
	
	# fileSystems."/mnt/profmat" = {
	# 	device = "orahcio@10.102.5.1:./";
	# 	fsType = "sshfs";
	# 	options = [
	# 		"nodev"
	# 		"noatime"
	# 		"allow_other"
	# 		"nofail"
	# 		"IdentityFile=/home/orahcio/.ssh/id_rsa"
	# 	];
	# };

  # enables support for Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
	services.blueman.enable = true;

  # Ativar a mesa digitalizadora
  hardware.opentabletdriver = {
    enable = true;
		package = pkgs.unstable.opentabletdriver;
    daemon.enable = true;
  };

  # Enable OpenGL
  # hardware.graphics.enable = true;
    # driSupport32Bit = true;

  services.xserver.videoDrivers = [ "modesetting" "noveau" ];
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "goldenfeynman"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Bahia";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

	# Login em texto
	services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${session}";
        user = "${username}";
      };
      default_session = {
        command = "${tuigreet} --greeting 'Oi você está no NixOS!' --asterisks --remember --remember-user-session --time -cmd '${session}'";
        user = "greeter";
      };
    };
  };

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # Enable automatic login for the user.
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "orahcio";

	# Enable sway window manager
	# Configuração que talvez necessite no sway para montar driver por exemplo
	security.polkit.enable = true;
 #  programs.sway = {
 #    enable = true;
	# 	package = pkgs.swayfx;
	# 	xwayland.enable = true;
 #    wrapperFeatures.gtk = true;
	# 	extraOptions = [ "--unsupported-gpu" ];
 #  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  # console.keyMap = "br-abnt2";
  console = {
    earlySetup = true;
    # font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    font = "ter-powerline-v16b";
    packages = with pkgs; [ 
      terminus_font
      powerline-fonts
      ];
    keyMap = "br-abnt2";
  };

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  
  # Virtualização virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Para ter o fish no sistema além do bash
  programs.fish.enable = true;
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.orahcio = {
    isNormalUser = true;
    description = "Orahcio Felício de Sousa";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "input" "video" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWas/W1GUZUrBaGdgUSEfI0mnucWrw+SZcKIbP3OTt5 orahcio@vaporhole.xyz" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.variables.EDITOR = "nvim";

	programs.fuse.userAllowOther = true;
  # Excluindo pacotes do plasma
  # environment.plasma6.excludePackages = with pkgs.kdePackages; [
    # plasma-browser-integration
    # oxygen
    # elisa
    # krdp
  # ];

  environment.systemPackages = with pkgs; [
    wget unrar bc entr openssl dmg2img gptfdisk btop lshw pciutils sshfs
    git # deixei pois o doas (substituto do suso) necessita ter o git no sistema
		fossil # outro versionamento, alternativa ao git
    fastfetch # Apresentação do sistema ao abrir o terminal
    # Para usar o doas mesmo com pacotes que só usam sudo, se necesitar da tag -e não funciona
    (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
		unstable.espanso-wayland

		# Joguinhos
		sdlpop # Prince of Persia velhão
		maelstrom
		];
  
  # Pacotes de fontes do sistema
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [
      "FiraCode"
      # "DroidSansMono"
      ]; })
    # corefonts
    # ibm-plex
		font-awesome_5
  ];

	# Para regular o brilho do monitor
	programs.light.enable = true;
  
  # Para jogar via steam com java
  programs.java.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # kde-connect program
  programs.kdeconnect.enable = true;
  
  # Aqui é para usar flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # doas ao invés de sudo
  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [{
    users = ["orahcio"];
    # Optional, retains environment variables while running commands 
    # e.g. retains your NIX_PATH when applying your config
    keepEnv = true; 
    persist = true;  # Optional, only require password verification a single time
  }];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:
  
  # Enable CUPS and CUPS to print documents and to PDF.
  services.printing = {
		enable = true;
    cups-pdf = {
      enable = true;
      instances = {
        Download_PDF = {
          settings = {
            Out = "\${HOME}/Downloads/cups-pdf";
            UserUMask = "0033";
          };
        };
      };
    };
  };

  # Mouse suport on tty
  services.gpm.enable = true;

  # Gerenciador de pacotes guix
  # talvez necessite usar `doas guix gc --verify=contents,repair`
  # para restaurar a store do guix, ref. resposta do dariqq no irc.libera.chat #guix
  services.guix = {
		enable = true;
		package = pkgs.unstable.guix;
	};

  # Flatpak (ref. https://matthewrhone.dev/nixos-package-guide)
  # xdg.portal.enable = true; # only needed if you are not doing Gnome
  # services.flatpak.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
	services.openssh.allowSFTP = true;
	
	# Montar pendrives
	services.gvfs.enable = true;
	services.udisks2.enable = true;
  services.devmon.enable = true;

	# Rede TOR
	services.tor = {
  	enable = true;
		torsocks.enable = true;
  	openFirewall = true;
	};

	# Geolocalização
	# services.geoclue2.enable = true;

	# Espanso
	# services.espanso = {
	# 	enable = true;
	# 	package = pkgs.espanso-wayland;
	# };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

	nix.settings.auto-optimise-store = true;

  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
