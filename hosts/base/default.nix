# base/default.nix is our template that will be universal across all builds
# supposed to cut down on overall lines of code
{ config, pkgs, ... }:
{
  # This fixes the "experimental feature" error
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # This fixes the <nixpkgs> error by linking the system's nixpkgs
  # to the legacy channels path
  nix.nixPath = [ "nixpkgs=${pkgs.path}" ];

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

  # security configs
  security.rtkit.enable = true;
  security.sudo-rs.enable = true;
  system.autoUpgrade.enable = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.initrd.supportedFilesystems = [ "zfs" ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # finally, read the manual before editing
  system.stateVersion = "25.11";

}
