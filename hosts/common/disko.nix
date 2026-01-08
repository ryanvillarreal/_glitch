{
  disko.devices = {
    disk = {
      main = {
        # this is gonna potentially change
        # also kinda dangerous lmao
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        # Standard ZFS properties
        rootFsOptions = {
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          home = {
            type = "zfs_fs";
            mountpoint = "/home";
          };
        };
      };
    };
  };
}
