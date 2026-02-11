{ pkgs, ... }:

{
  system.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # pull in dependencies
  imports = [
     ./hardware-configuration.nix
     <home-manager/nixos>
  ];

  # hardware configs
  hardware = {
    graphics = {
      enable32Bit = true;
      enable = true;
    };
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };


  # load users
  users.users.null = {
    isNormalUser = true;
    initialPassword = "null";
    home = "/home/null";
    description = "null";
    extraGroups = [ "wheel" "null" ];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYRBxAcBhbKHwXrOrvDDP8NfIZb6HvF9VNjk0gHC4PR null@xjcrazy09.com"
    ];
  };
  