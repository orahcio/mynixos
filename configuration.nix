# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =
    [ # Include the results of the hardware scan. # home-manager.nixosModule
      ./hardware-configuration.nix
      # <home-manager/nixos>
    ];


  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_4_19;
    supportedFilesystems = [ "ntfs" ];
    loader = {
      # systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        # gfxmodeEfi = "1920x1080";
        # theme = "${pkgs.kdePackages.breeze-grub}/grub/themes/breeze";
      };
    };
    plymouth.enable = true;
  };
  boot.loader.grub2-theme = {
    enable = true;
    theme = "tela";
    footer = true;
  };
  # boot.kernelPackages = pkgs.linuxPackages_4_19;
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # boot.plymouth.enable = true;

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

  # Otimização do disco, no reddit do nixos disse que seria uma boa
  services.fstrim.enable = true;

  # SAMBA
  services.gvfs.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ]; # "modesetting"

  hardware.nvidia = {
    
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
	      enable = true;
	      enableOffloadCmd = true;
	    };
		  nvidiaBusId = "PCI:1:0:0";
		  intelBusId = "PCI:0:2:0";
    };
  };

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    sddm.wayland.enable = true;
    defaultSession = "plasma";
    autoLogin.user = "orahcio";
  };
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents and to PDF.
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

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  security.rtkit.enable = true;
  #services.pipewire = {
  #  enable = true;
  #  alsa.enable = true;
  #  alsa.support32Bit = true;
  #  pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  #};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Flatpack
  xdg.portal.enable = true;
  services.flatpak.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # # Montar Googledrive com ocamfuse depois de se conectar a internet
  # # Lembrar que só faz sentido depois de configurar o google-drive-ocamfuse
  # systemd.services.orahcioDrive = {
  #   # só inicia o serviço depois que fazer o login
  #   wantedBy = [ "multi-user.target" ];
  #   # assim que tiver online o serviço excecuta
  #   after = [ "network.target" ];
  #   description = "Montar meu drive pessoal assim que logar na rede";
  #   serviceConfig = {
  #     Type = "forking";
  #     User = "orahcio";
  #     ExecStart = ''google-drive-ocamfuse /home/orahcio/GoogleDrive'';
  #     ExecStop = ''fusermount -u /home/orahcio/GoogleDrive'';
  #     Restart = "always";
  #   };
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.variables.EDITOR = "nvim";
  environment.systemPackages = with pkgs; [
    # (import ./vim.nix) # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    pciutils
    tarlz unzip gzip unrar bzip2 p7zip binutils-unwrapped-all-targets
    fastfetch
    git # para usar o doas ao invés do sudo o systema tem que ter o git
    ngrok
    killall
    bc
    sshfs
    bup
    lshw
    typioca
    ark
    twtxt
    megasync
    dropbox
    vlc
    ffmpeg
    sqlitebrowser
    (lutris.override {
      extraLibraries = pkgs: [
        giflib libpng libpulseaudio libgpg-error alsa-plugins alsa-lib libjpeg xorg.libXcomposite xorg.libXinerama libgcrypt libxslt libva gst_all_1.gst-plugins-base
      ];
    })
    (lutris.override {
      extraPkgs = pkgs: [
        wineWowPackages.stable gnutls openal sqlite v4l-utils gtk3 ocl-icd vulkan-tools mpg123 ncurses 
      ];
    })
    kdenlive
    mediainfo
    filelight
    # layan-kde
    libreoffice-qt-fresh
    hunspell
    hunspellDicts.en_US
    hunspellDicts.pt_BR
    aspell
    aspellDicts.pt_BR
    kile
    kdePackages.kdeconnect-kde
    kdePackages.kwrited
    kdePackages.kruler
    # kdePackages.kasts
    kdePackages.kcalc
    kdePackages.ktorrent
    kdePackages.kbackup
    kdePackages.partitionmanager
    kdePackages.oxygen
    kdePackages.oxygen-icons
    kdePackages.kparts
    pdfarranger
    obs-studio
    arduino-cli
    appimage-run
    gparted
    usbimager
  ];
  
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [
      "Meslo"
      "FiraCode"
      "DroidSansMono"
      "ZedMono"
      ]; })
    corefonts
    liberation_ttf_v1
  ];

  programs.java.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  
  # Ollama server para ter uma IA localmente
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  
  # Coloquei essa linha pra mexer no arquivo /etc/fuse.conf
  programs.fuse.userAllowOther = true;
  # Adicionar o fish como um shell do sistema além do bash
  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.orahcio = {
    isNormalUser = true;
    description = "Orahcio Felício de Sousa";
    extraGroups = [ "networkmanager" "wheel" "audio" "libvirtd" ];
    shell =pkgs.fish;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWas/W1GUZUrBaGdgUSEfI0mnucWrw+SZcKIbP3OTt5 orahcio@vaporhole.xyz" ];
  };

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
  
  # users.users.ilana = {
  #   isNormalUser = true;
  #   description = "Rosa Ilana dos Santos";
  #   extraGroups = ["networkmanager" "audio"];
  # };

  # Garbage-collect, deletar gerações mais velhas que trinta dias, semanalmente
  nix.gc = {
    automatic =true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  # Open ports in the firewall.
  # Abrir portas para Diablo III e kdeconnect
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 25565 ];
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; }
    ];
    allowedUDPPorts = [ 6112 ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; }
    ];
    extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  };
  
  # Espço otimizado ligado
  nix.settings.auto-optimise-store = true;
  # Flakes enabled
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  security.polkit.enable = true;

  nixpkgs.config.permittedInsecurePackages = [ "freeimage-unstable-2021-11-01" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
