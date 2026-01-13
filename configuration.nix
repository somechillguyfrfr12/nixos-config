# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # kernel
   boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
programs.gamemode.enable = true;



  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Gaza";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;
    
  # flatpak service
   services.flatpak.enable = true;  

  # cpu freq i guess
  services.auto-cpufreq.enable = true;

  # zram for gayming
   zramSwap.enable = true;

  
     # Hyprland (Wayland compositor)
  programs.hyprland.enable = true;

environment.sessionVariables = {
  NIXOS_OZONE_WL = "1";
  WLR_NO_HARDWARE_CURSORS = "1"; # avoids cursor stutter on NVIDIA
  __GL_GSYNC_ALLOWED = "1";
  __GL_VRR_ALLOWED = "1";
  __GL_MaxFramesAllowed = "1"; # reduces render queue latency
};

powerManagement.cpuFreqGovernor = "schedutil";


  # Enable the KDE Plasma Desktop Environment.

services.displayManager.sddm = {
  enable = true;
  wayland.enable = true;
};
 
 # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # flake
  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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


     programs.zsh.enable = true;
  users.extraUsers.idk = {
    shell = pkgs.zsh;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.idk = {
    isNormalUser = true;
    description = "idk";
    extraGroups = [ "networkmanager" "wheel" ];
  };


  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    open = true;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };


nix.settings.auto-optimise-store = true;
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
};

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


programs.thunar.enable = true;
programs.xfconf.enable = true;
programs.thunar.plugins = with pkgs.xfce; [
  thunar-archive-plugin
  thunar-volman
];
services.tumbler.enable = true; # Thumbnail support for images

   programs.steam = {
  enable = true;
};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    htop
    vim
    zathura
    xclicker
    protonup-qt
    waypaper 
    brightnessctl
    pavucontrol
    #spotify
    qbittorrent
    vesktop
    prismlauncher
    nitch
    nwg-look
    adw-gtk3
    papirus-icon-theme
    apple-cursor 
    swaynotificationcenter
    git
    unzip
    wget
    kitty
    vscodium
    grim
    slurp
    wl-clipboard
    swappy
    libnotify
    swww
    waybar
    rofi
    wofi
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}

