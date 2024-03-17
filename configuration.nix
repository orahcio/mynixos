# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan. # home-manager.nixosModule
      ./hardware-configuration.nix
      # <home-manager/nixos>
    ];


  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_4_19;
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        # enable = true;
        efiSupport = true;
        device = "nodev";
        gfxmodeEfi = "1920x1080";
      };
    };
    plymouth.enable = true;
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

  services.xserver.videoDrivers = [ "modesetting" ]; # "nvidia"

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.desktopManager.plasma6.enable = true;
  services.xserver.displayManager = {
    sddm.enable = true;
    # lightdm.enable = true;
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
  programs.java = { enable = true; package = pkgs.openjdk19; };

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
    neofetch
    killall
    bc
    kup
    bup
    lshw
    tdesktop
    ark
    megasync
    vlc
    ffmpeg
    sqlitebrowser
    corefonts
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
    layan-kde
    libreoffice-qt
    hunspell
    hunspellDicts.en_US
    aspell
    aspellDicts.pt_BR
    libsForQt5.kdeconnect-kde
    libsForQt5.accounts-qt
    libsForQt5.kwrited
    libsForQt5.kate
    libsForQt5.falkon
    libsForQt5.kdegraphics-thumbnailers    
    libsForQt5.kruler
    libsForQt5.kasts
    libsForQt5.neochat
    libsForQt5.kcalc
    libsForQt5.kontact
    libsForQt5.kmail
    libsForQt5.akonadi
    libsForQt5.ktorrent
    pdfarranger
    obs-studio
    arduino-cli
    appimage-run
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.orahcio = {
    isNormalUser = true;
    description = "Orahcio Felício de Sousa";
    extraGroups = [ "networkmanager" "wheel" "audio" "libvirtd" ];
  };
  
  # users.users.ilana = {
  #   isNormalUser = true;
  #   description = "Rosa Ilana dos Santos";
  #   extraGroups = ["networkmanager" "audio"];
  # };

  # Garbage-collect, deletar gerações mais velhas que trinta dias, semanalmente
  nix.gc = {
    automatic =true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
