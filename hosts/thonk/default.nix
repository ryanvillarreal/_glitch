{ config, pkgs, ... }:
{
  # build file system first and foremost
  imports = [ ../common/disko.nix ];

  # personal preference cause i'm lazy
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8812au ];

  # security configs
  security.rtkit.enable = true;
  security.sudo-rs.enable = true;
  system.autoUpgrade.enable = true;

  # new fs who dis?
  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ];

  # network
  networking = {
    hostName = "thonkpad";
    networkmanager.enable = true;
    # how do I fix this for vms? or dynamic?
    hostId = "0fadedaf"; # required for zfs should make this more dynamic

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="aa:92:ef:94:eb:63", NAME="alfa"
  '';

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # eventually move to using git sub-modules for user management
  users.users.null = {
    isNormalUser = true;
    initialPassword = "null";
    home = "/home/null";
    description = "null";
    extraGroups = [
      "wheel"
      "null"
      "docker"
    ];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYRBxAcBhbKHwXrOrvDDP8NfIZb6HvF9VNjk0gHC4PR null@xjcrazy09.com"
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  programs = {
    hyprland.enable = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    waybar
    wezterm
    wofi
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  virtualisation.docker = {
    enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "25.11";
}
