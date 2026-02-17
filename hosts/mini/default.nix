{
  inputs,
  config,
  pkgs,
  ...
}:
{
  # build file system first and foremost
  # imports = [ 
  #   ../base/default.nix
  # ];
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

  # network should be uniq for each machine
  networking = {
    hostName = "mini";
    networkmanager.enable = true;
    # Generate hostId automatically based on hostname
    hostId = builtins.substring 0 8 (builtins.hashString "sha256" "mini");
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

  users.users.xj = {
    isNormalUser = true;
    initialPassword = "xj"; # force change on first login?
    home = "/home/xj";
    description = "xj";
    extraGroups = [
      "wheel"
      "null"
      "xj"
    ];

    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMYRBxAcBhbKHwXrOrvDDP8NfIZb6HvF9VNjk0gHC4PR null@xjcrazy09.com"
    ];
  };

  # --- The Home Manager Handoff (Top Level) ---
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Pass inputs down so xj's flake can see its own dependencies
    extraSpecialArgs = { inherit inputs; };

    users.xj = {
      imports = [ inputs.xj.homeManagerModules.default ];
    };
  };
}
