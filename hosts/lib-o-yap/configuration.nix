{ config, lib, pkgs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ZFS support
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelModules = [ "zfs" ];
  boot.zfs.extraPools = [ "tank" ];

  # Btrfs compression
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  services.btrfs.autoScrub.enable = true;

  # Networking
  networking.hostName = "lib-o-yap";
  networking.hostId = "bcc4454e";  # Required for ZFS
  networking.networkmanager.enable = true;

  # User
  users.users.shop = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "24.05";
}
