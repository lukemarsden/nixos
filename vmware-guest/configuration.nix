# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  boot.supportedFilesystems = [ "zfs" ];

  networking.hostId = "cafebabe";

  networking.hostName = "zippy"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

  networking.extraHosts = "127.0.0.1 ${config.networking.hostName}.local";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/London";

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
  #  chromium
    vim
    docker
    docker_compose
  #  slack
    universal-ctags
    mtr
    go
    jq
    tmux
    tmate
    gnumake
    git
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  #services.xserver = {
  #  enable = true;
  #  layout = "gb";
  #  libinput.enable = true;
  #  synaptics.enable = false;
  #  # services.xserver.xkbOptions = "eurosign:e";
  #
  #  config = ''
  #    Section "InputClass"
  #      Identifier     "Enable libinput for TrackPoint"
  #      MatchIsPointer "on"
  #      Driver         "libinput"
  #    EndSection
  #  '';
  #
  #  displayManager.gdm.enable = true;
  #
  #  desktopManager = {
  #    gnome3.enable = true;
  #    default = "gnome3";
  #  };
  #};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.luke = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" ];
  };

  security.sudo.wheelNeedsPassword = false;

  boot.kernel.sysctl."vm.max_map_count" = 262144;

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
    extraOptions = "--insecure-registry ${config.networking.hostName}.local:80";
  };

  system.activationScripts.binbash = {
    text = "ln -sf /run/current-system/sw/bin/bash /bin/bash";
    deps = [];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
