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
  boot.kernelPackages = pkgs.linuxPackages_4_19;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.plymouth.enable = true;

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
  
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  hardware.opengl.driSupport32Bit = true;
  hardware.opentabletdriver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "br";
    xkbVariant = "";
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
    kup
    bup
    firefox
    mailspring
    microsoft-edge
    tdesktop
    ark
    megasync
    vlc
    ffmpeg
    sqlitebrowser
    wineWowPackages.staging
    winetricks
    grapejuice
    lutris
    (lutris.override {
      extraLibraries = pkgs: [
        giflib libpng libpulseaudio libgpg-error alsa-plugins alsa-lib libjpeg xorg.libXcomposite xorg.libXinerama libgcrypt libxslt libva gst_all_1.gst-plugins-base
      ];
    })
    (lutris.override {
      extraPkgs = pkgs: [
        wine-staging gnutls openal sqlite v4l-utils gtk3 ocl-icd vulkan-tools mpg123 ncurses 
      ];
    })
    xournalpp
    inkscape
    gimp
    krita
    kdenlive
    mediainfo
    filelight
    layan-kde
    zotero
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

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  # Virtualbox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.x11 = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.orahcio = {
    isNormalUser = true;
    description = "Orahcio Felício de Sousa";
    extraGroups = [ "networkmanager" "wheel" "audio" "vboxusers" ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.defaultSession = "plasmawayland";
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "orahcio";

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
  # nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
