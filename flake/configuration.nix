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
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "snow"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
  networking.wireless.networks."AMRITA-Connect"= {
    auth = ''
      key_mgmt=WPA-EAP
      eap=PEAP
      phase1="peaplabel=auto tls_disable_tlsv1_0=0 tls_disable_tlsv1_1=0 tls_disable_tlsv1_2=0 tls_ext_cert_check=0"
      phase2="auth=MSCHAPV2"
      identity="am.en.u4cse22004@am.students.amrita.edu"
      password="CZNoWlaG"
      '';
    };
    networking.wireless.networks."0x168"= {
  
    };

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

 # i18n.extraLocaleSettings = {
 #   LC_ADDRESS = "en_IN";
 #   LC_IDENTIFICATION = "en_IN";
 #   LC_MEASUREMENT = "en_IN";
 #   LC_MONETARY = "en_IN";
 #   LC_NAME = "en_IN";
 #   LC_NUMERIC = "en_IN";
 #   LC_PAPER = "en_IN";
 #   LC_TELEPHONE = "en_IN";
 #   LC_TIME = "en_IN";
 #   LC_ALL = "en_IN";
 #   LC_CTYPE  = "en_IN";
 #   LANGUAGE = "en_IN"; 
 # };
 
 # Fonts
 fonts.fonts = with pkgs; [
   (nerdfonts.override { fonts = ["JetBrainsMono"]; })
 ];


  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the XFCE and i3
  #services.xserver.windowManager.i3.enable = true;
  #services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  programs.hyprland.enable=true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.winters = {
    isNormalUser = true;
    description = "Winters";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    vscode
    htop
    discord
    git
    wezterm
    alacritty
#    burpsuite
    nitrogen 
    rofi
    lm_sensors
    picom
    file
    polybar
    cava
    i3blocks
    nodejs
    acpi
    sysstat
    zip
    gcc
    unzip
    wofi
    waybar
    wbg
    nitch
    (python38.withPackages(ps: with ps; [requests]))
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
  
  #Enable Flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
