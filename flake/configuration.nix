# Winters

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Enable networking
  #networking.networkmanager.enable = true;
  networking.hostName = "frost"; 
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
  networking.wireless.networks."AMRITA-Connect"= {
    auth = ''
      key_mgmt=WPA-EAP
      eap=PEAP
      phase1="peaplabel=auto tls_disable_tlsv1_0=0 tls_disable_tlsv1_1=0 tls_disable_tlsv1_2=0 tls_ext_cert_check=0"
      phase2="auth=MSCHAPV2"
      identity="am.en.u4cse22004@am.students.amrita.edu"
      password="REDACTED"
      '';
    };
  networking.wireless.networks."0x168"= {

  };
  
  # Enable virtualization
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  
  # Enable Bluetooth support
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable docker
  virtualisation.docker.enable = true;

  # Enable Power management
  # if you already have boot.kernelParams config, just add "intel_pstate=disable" to the list
  boot.kernelParams = [ "intel_pstate=disable" ];
  services.tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
          CPU_SCALING_GOVERNOR_ON_BAT = "schedutil";

          # Refer to the output of tlp-stat -p to determine the active scaling driver and available governors.
          # https://linrunner.de/tlp/settings/processor.html#cpu-scaling-min-max-freq-on-ac-bat
          CPU_SCALING_MIN_FREQ_ON_AC = 800000;
          CPU_SCALING_MAX_FREQ_ON_AC = 1800000;
          CPU_SCALING_MIN_FREQ_ON_BAT = 800000;
          CPU_SCALING_MAX_FREQ_ON_BAT = 1800000;
        };
      };
  # Enable MYSQL
  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;
  services.mysql.user = "winters";
  services.longview.mysqlPassword = "root";
  
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";
 
 # Fonts
 fonts.fonts = with pkgs; [
   (nerdfonts.override { fonts = ["JetBrainsMono"]; })
 ];


  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE and i3
  programs.hyprland.enable=true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.winters = {
    isNormalUser = true;
    description = "Winters";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
      firefox
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #Enable ZSH and features
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.ohMyZsh.theme = "half-life";
  users.defaultUserShell = pkgs.zsh;

 
  environment.systemPackages = with pkgs; [
    vim 
    wget
    vscode
    htop
    discord
    git
    alacritty
    burpsuite
    lm_sensors
    file
    cava
    nodejs-19_x
    zip
    gcc
    unzip
    wofi
    wbg
    nitch
    chromium
    pipes
    cbonsai
    pamixer
    php
    wpa_supplicant_gui
    ranger
    nodejs-19_x
    jekyll
    rustup
    p7zip
    virt-manager
    (python38.withPackages(ps: with ps; [requests pip]))
  ];

  #Enable Flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.stateVersion = "22.11"; 
}
