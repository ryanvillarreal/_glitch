{ config, pkgs, ... }:
{
  # build file system first and foremost
  imports = [ ../base/default.nix ];

  # network should be uniq for each machine
  networking = {
    hostName = "mini";
    networkmanager.enable = true;
    # how do I fix this for vms? or dynamic?
    hostId = "0fadedaf"; # required for zfs should make this more dynamic or auto-ge

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ]; # always allow ssh
    };
  };

  # Set your time zone.
  # are we leaving this in the uniq machine settings for cloud deployment?
  time.timeZone = "America/New_York";

  # eventually move to using git sub-modules for user management?
  # is that even possible?
  # for now we only hadd the users we want to support in the uniq machine nix files
  users.users.null = {
    isNormalUser = true;
    initialPassword = "null"; # force change on first login
    home = "/home/null";
    description = "null";
    extraGroups = [
      "wheel"
      "null"
    ];

    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYRBxAcBhbKHwXrOrvDDP8NfIZb6HvF9VNjk0gHC4PR null@xjcrazy09.com"
    ];
  };

}
